define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/annotations/annotations_item')
  ModalConfirmView = require('views/modal/modal_confirm')

  class AnnotationItem extends Marionette.ItemView

    highlighted: true
    ignoreTime: false
    template: template
    tagName: 'li'
    className: 'annotation'

    triggers:
      'click @ui.destroy': 'annotation:destroy'
      'click @ui.edit': 'annotation:edit'
      'click @ui.timecode': 'seek'

    ui: {
      timecode: '[data-behavior="timecode"]'
      destroy: '[data-behavior="destroy"]'
      edit: '[data-behavior="edit"]'
    }

    modelEvents: {
      "change": "onModelChange"
    },

    onModelChange: () ->
      @render()

    setupListeners: () ->
      @listenTo(@model,'change:active', @handleActiveStateChange)

    handleActiveStateChange: () ->
      if @model.get('active') == true
        @trigger('activated', @)

    updateHighlightState: () ->
      if @model.get('active') == true
        @$el.addClass('active')
      else
        @$el.removeClass('active')

    initialize: (options) ->
      @vent = options.vent
      @errorVent = options.errorVent
      @setupListeners()

    remove: () ->
      @trigger('before:remove')
      @$el.slideUp(200, () =>
        @$el.remove()
        @trigger('after:remove')
      )

    onSeek: () ->
      console.log 'seeking'
      @vent.trigger('request:time:update', {seconds: @model.get('seconds_timecode')})

    onAnnotationDestroy: () ->
      console.log 'heard the click event'
      @vent.trigger('request:pause', {})
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Are you sure you want to delete this annotation? Deleted annotations cannot be recovered.',
        confirmEvent: 'confirm:destroy',
        dismissEvent: 'dismiss:destroy'
      }))

    onConfirmDestroy: () ->
      @model.destroy({
        success: () =>
          Vocat.vent.trigger('error:add', {level: 'notice', lifetime: '5000',  msg: 'The annotation has been successfully deleted.'})
      , error: (xhr) =>
          Vocat.vent.trigger('error:add', {level: 'notice', msg: xhr.responseJSON.errors})
      })
      @vent.trigger('request:resume', {})

    onDismissDestroy: () ->
      @vent.trigger('request:resume', {})

    onAnnotationEdit: () ->
      @vent.trigger('edit:annotation', @model)