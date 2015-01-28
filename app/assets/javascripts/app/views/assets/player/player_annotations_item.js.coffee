define (require) ->

  Marionette = require('marionette')

  class PlayerAnnotationItem extends Marionette.ItemView

    template: _.template('')
    tagName: 'li'
    showTimePadding: 1
    hideTimePadding: .1
    assetHasDuration: false
    hidden: false
    animating: false

    initialize: (options) ->
      @vent = options.vent
      @assetHasDuration = options.assetHasDuration
      @setupListeners()

    setupListeners: () ->
      @listenTo(@model, 'change:canvas', @render, @)
      @listenTo(@vent, 'announce:canvas:enabled', @handleCanvasEnabled, @)
      @listenTo(@vent, 'announce:canvas:disabled', @handleCanvasDisabled, @)
      if @assetHasDuration
        @listenTo(@vent, 'announce:time:update', @handleTimeUpdate, @)
        @listenTo(@vent, 'announce:status', @handleTimeUpdate, @)
      else
        @listenTo(@model, 'change:active', @handleActiveChange, @)

    handleCanvasEnabled: () ->
      @hideEl()

    handleCanvasDisabled: () ->
      if @model.get('active') == true
        @showEl()

    handleActiveChange: () ->
      if @model.get('active') == true
        @$el.fadeIn(250)
      else
        @$el.fadeOut(250)

    hideEl: () ->
      @hidden = true
      @$el.hide()

    showEl: () ->
      @hidden = false
      @$el.show()

    fadeOut: (time) ->
      if !@animating
        @$el.stop()
        @animating = true
        @$el.fadeOut(time, () =>
          @state = 'hidden'
        )

    highlight: () ->
      @animating = false
      @$el.stop()
      @$el.css({opacity: 1})
      #@$el.toggle('pulsate', {times: 1})
      @$el.show()

    fadeIn: (time) ->
      if !@animating
        @$el.stop()
        @animating = true
        @$el.fadeTo(time, .3, () =>
          @animating = false
        )

    handleTimeUpdate: (data) ->
      playbackTime = data.playedSeconds
      annotationTime = @model.get('seconds_timecode')

      showTime = annotationTime - @showTimePadding
      hideTime = annotationTime + @hideTimePadding

      if playbackTime > hideTime
        @fadeOut(250)
      else if playbackTime >= annotationTime - .25 && playbackTime <= hideTime
        @highlight()
      else if playbackTime >= showTime
        @fadeIn(500)
      else if playbackTime <= showTime - .5
        @hideEl()

    onRender: () ->
      svg = @model.getSvg()
      @$el.html(svg)
      @$el.attr({'data-model-id': @model.id})
      @hideEl()
