define (require) ->

  Marionette = require('marionette')

  class PlayerAnnotationItem extends Marionette.ItemView

    template: _.template('')
    tagName: 'li'
    showTimePadding: .25

    initialize: (options) ->
      @vent = options.vent
      @setupListeners()

    setupListeners: () ->
      @listenTo(@vent, 'announce:time:update', @handleTimeUpdate, @)

    handleTimeUpdate: (data) ->
      playbackTime = data.playedSeconds
      showTime = @model.get('seconds_timecode')
      if showTime > playbackTime + @showTimePadding || showTime  < playbackTime - @showTimePadding
        @$el.fadeOut(200)
      else
        @$el.fadeIn(200)

    onRender: () ->
      svg = @model.getSvg()
      @$el.html(svg)
      @$el.attr({'data-model-id': @model.id})
      @$el.hide()
