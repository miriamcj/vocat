define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/annotations/annotations_item')

  class AnnotationItem extends Marionette.ItemView

    highlighted: true
    ignoreTime: false
    template: template
    tagName: 'li'
    className: 'annotations--item'

    triggers:
      'click @ui.destroy': 'annotation:destroy'
      'click @ui.seek': 'seek'

    ui: {
      destroy: '[data-behavior="destroy"]'
      seek: '[data-behavior="seek"]'
    }

    initialize: (options) ->
      @vent = options.vent
      @errorVent = options.errorVent

    enableEdit: () ->
      @ui.destroy.slideDown(200)

    disableEdit: () ->
      @ui.destroy.slideUp(200)

    highlightableFor: (seconds) ->
      @model.get('seconds_timecode') <= seconds

    highlight: () ->
      @$el.addClass('highlighted')

    dehighlight: () ->
      @$el.removeClass('highlighted')

    remove: () ->
      @$el.slideUp(200, () ->
       $(@).remove()
      )

    onSeek: () ->
      @vent.triggerMethod('player:seek', {seconds: @model.get('seconds_timecode')})

    onAnnotationDestroy: () ->
      @model.destroy({
        success: () =>
          @errorVent.trigger('error:clear')
          @errorVent.trigger('error:add', {level: 'notice', lifetime: '5000',  msg: 'annotation successfully deleted'})
      , error: (xhr) =>
          @errorVent.trigger('error:clear')
          @errorVent.trigger('error:add', {level: 'notice', msg: xhr.responseJSON.errors})
      })
