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
      'click [data-behavior="destroy"]': 'destroy'
      'click [data-behavior="seek"]': 'seek'

    initialize: (options) ->
      @vent = options.vent
      @errorVent = options.errorVent

#      @listenTo(@vent, 'show:all', () =>
#        @ignoreTime = true
#        @show()
#      )

#      @listenTo(@vent, 'show:auto', () =>
#        @ignoreTime = false
#      )

#
#      @listenTo(@vent, 'player:time', (data) =>
#        if @ignoreTime == false
#          if @model.get('seconds_timecode') <= data.seconds
#            @show()
#      )
#
#      @listenTo(@vent, 'annotation:shown', (shownView) =>
#        if shownView != @
#          @hide()
#      )

    highlightableFor: (seconds) ->
      @model.get('seconds_timecode') <= seconds

    highlight: () ->
      @$el.addClass('highlighted')

    dehighlight: () ->
      @$el.removeClass('highlighted')

    onBeforeRender: () ->

    onSeek: () ->
      @vent.triggerMethod('player:seek', {seconds: @model.get('seconds_timecode')})

    onDestroy: () ->
      @model.destroy({
        success: () =>
          @errorVent.trigger('error:clear')
          @errorVent.trigger('error:add', {level: 'notice', lifetime: '5000',  msg: 'annotation successfully deleted'})
      , error: () =>
          @errorVent.trigger('error:clear')
          @errorVent.trigger('error:add', {level: 'notice', msg: xhr.responseJSON.errors})
      })