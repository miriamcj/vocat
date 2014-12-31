define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/annotator/progress_bar_annotation')

  class ProgressBarAnnotation extends Marionette.ItemView

    template: template
    triggers: {
      'click': 'seek'
    }
    tagName: 'li'

    onSeek: () ->
      @vent.trigger('request:time:update', {seconds: @model.get('seconds_timecode')})

    setupListeners: () ->
      @listenTo(@vent, 'announce:status', (data) =>
        @updatePosition(data.duration)
      )

    updatePosition: (duration) ->
      if duration == 0
        @$el.hide()
      else
        time = @model.get('seconds_timecode')
        percentage = (time / duration) * 100
        @$el.css({left: "#{percentage}%"})
        @$el.show()

    initialize: (options) ->
      @vent = options.vent
      @setupListeners()


    onRender: () ->
      role = @model.get('author_role')
      switch role
        when "administrator"
          @$el.addClass('role-administrator')
        when "evaluator"
          @$el.addClass('role-evaluator')
        when "creator"
          @$el.addClass('role-creator')
        when "self"
          @$el.addClass('role-self')

