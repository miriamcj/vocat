define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/annotations/annotations_item')
  ModalConfirmView = require('views/modal/modal_confirm')

  class AnnotationItem extends Marionette.ItemView

    assetHasDuration: false
    highlighted: true
    ignoreTime: false
    template: template
    tagName: 'li'
    className: 'annotation'

    triggers:
      'click @ui.destroy': {
        event: 'annotation:destroy'
        stopPropagation: true
      }
      'click @ui.edit': {
        event: 'annotation:edit'
        stopPropagation: true
      }
      'click @ui.seek': {
        event: 'seek'
        stopPropagation: false
      }
      'click @ui.activate': {
        event: 'activate'
        stopPropagation: false
      }
      'click @ui.body': {
        event: 'toggle'
        stopPropagation: false
      }

    ui: {
      seek: '[data-behavior="seek"]'
      destroy: '[data-behavior="destroy"]'
      edit: '[data-behavior="edit"]'
      body: '[data-behavior="annotation-body"]'
      activate: '[data-behavior="activate"]'
    }

    modelEvents: {
      "change:body": "onModelBodyChange"
    },

    onActivate: () ->
      @model.collection.activateModel(@model)
      @vent.trigger('request:annotation:show', @model)

    onModelBodyChange: () ->
      @render()

    onToggle: () ->
      @$el.toggleClass('annotation-open')

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
      @assetHasDuration = options.assetHasDuration
      @setupListeners()

    remove: () ->
      @trigger('before:remove')
      @$el.slideUp(200, () =>
        @$el.remove()
        @trigger('after:remove')
      )

    onSeek: () ->
      @vent.trigger('request:time:update', {seconds: @model.get('seconds_timecode')})

    onAnnotationDestroy: () ->
      @vent.trigger('request:pause', {})
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Are you sure you want to delete this annotation? Deleted annotations cannot be recovered.',
        confirmEvent: 'confirm:destroy',
        dismissEvent: 'dismiss:destroy'
      }))

    serializeData: () ->
      data = super()
      data.assetHasDuration = @assetHasDuration
      data

    onConfirmDestroy: () ->
      @model.destroy({
        success: () =>
          Vocat.vent.trigger('error:add', {level: 'notice', clear: true, lifetime: '5000',  msg: 'The annotation has been successfully deleted.'})
      , error: (xhr) =>
          Vocat.vent.trigger('error:add', {level: 'notice', msg: xhr.responseJSON.errors})
      })
      @vent.trigger('request:resume', {})

    onDismissDestroy: () ->
      @vent.trigger('request:resume', {})

    onAnnotationEdit: () ->
      @vent.trigger('edit:annotation', @model)