define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/annotations/annotations_item')

  class AnnotationItem extends Marionette.ItemView

    highlighted: true
    ignoreTime: false
    template: template
    tagName: 'li'
    className: 'annotation'

    triggers:
      'click @ui.destroy': 'annotation:destroy'
      'click': 'seek'

    ui: {
      destroy: '[data-behavior="destroy"]'
    }

    setupListeners: () ->
      @listenTo(@model,'change:active', @updateHighlightState)

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
      @$el.slideUp(200, () ->
       $(@).remove()
      )

    onSeek: () ->
      @vent.trigger('request:time:update', {seconds: @model.get('seconds_timecode')})

    onAnnotationDestroy: () ->
      @model.destroy({
        success: () =>
          Vocat.vent.trigger('error:add', {level: 'notice', lifetime: '5000',  msg: 'annotation successfully deleted'})
      , error: (xhr) =>
          Vocat.vent.trigger('error:add', {level: 'notice', msg: xhr.responseJSON.errors})
      })
