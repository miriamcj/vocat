define (require) ->

  Marionette = require('marionette')

  class PlayerAnnotationItem extends Marionette.ItemView

    template: _.template('')
    tagName: 'li'
    showTimePadding: .25
    assetHasDuration: false

    initialize: (options) ->
      @vent = options.vent
      @assetHasDuration = options.assetHasDuration
      @setupListeners()

    setupListeners: () ->
      if @assetHasDuration
        @listenTo(@vent, 'announce:time:update', @handleTimeUpdate, @)
      else
        @listenTo(@model, 'change:active', @handleActiveChange, @)

    handleActiveChange: () ->
      if @model.get('active') == true
        @$el.fadeIn(200)
      else
        @$el.fadeOut(200)

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
