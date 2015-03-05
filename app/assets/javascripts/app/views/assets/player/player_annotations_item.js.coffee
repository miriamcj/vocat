define (require) ->

  Marionette = require('marionette')

  class PlayerAnnotationItem extends Marionette.ItemView

    template: _.template('')
    tagName: 'li'

    fadeInBeforeAnnotationTime: .75
    fadeOutAfterAnnotationTime: .1
    highlightBeforeAnnotationTime: .25
    visibilityTriggers: {
      beforeShow: null
      fadeIn: null
      highlight: null
      fadeOut: null
      afterShow: null
    }

    # null = unset, 0 = beforeShow, 1 = fadeIn, 2 = highlight, 3 = fadeOut, 4 = afterShow
    state: null

    assetHasDuration: false
    animating: false
    annotationTime: null

    canTransitionTo: (state) ->
      if @state != state
        true
      else
        false

    updateState: (state) ->
      @state = state
      switch state
        when 0
          @hideEl()
        when 1
          @fadeIn(500)
        when 2
          @highlight()
        when 3
          @fadeOut(250)
        when 4
          @fadeOut(0)

    setState: (state) ->
      if @canTransitionTo(state)
        @updateState(state)

    updateVisibility: (data) ->
      time = data.playedSeconds
      return @setState(0) if time < @visibilityTriggers['beforeShow']
      return @setState(4) if time > @visibilityTriggers['afterShow']
      return @setState(3) if time > @visibilityTriggers['fadeOut']
      return @setState(2) if time > @visibilityTriggers['highlight']
      return @setState(1) if time > @visibilityTriggers['fadeIn']

    initialize: (options) ->
      @vent = options.vent
      @assetHasDuration = options.assetHasDuration
      @annotationTime = @model.get('seconds_timecode')
      @updateVisibilityTriggers()
      @setupListeners()

    updateVisibilityTriggers: () ->
      annotationTime = @model.get('seconds_timecode')
      @visibilityTriggers = {}
      @visibilityTriggers['beforeShow'] = annotationTime - @fadeInBeforeAnnotationTime
      @visibilityTriggers['fadeIn'] = annotationTime - @fadeInBeforeAnnotationTime
      @visibilityTriggers['highlight'] = annotationTime - @highlightBeforeAnnotationTime
      @visibilityTriggers['fadeOut'] = annotationTime + @fadeOutAfterAnnotationTime
      @visibilityTriggers['afterShow'] = annotationTime + @fadeOutAfterAnnotationTime + 250

    setupListeners: () ->
      @listenTo(@vent, 'announce:time:update', @updateVisibility, @) if @assetHasDuration
      @listenTo(@vent, 'announce:status', @updateVisibility, @) if @assetHasDuration
      @listenTo(@vent, 'announce:annotator:input:start', @concealAnnotation, @)

      @listenTo(@model, 'change:seconds_timecode', @updateVisibilityTriggers, @)
      @listenTo(@model, 'change:canvas', @render, @)
      @listenTo(@model, 'change:active', @handleActiveChange, @) unless @assetHasDuration

    concealAnnotation: () ->
      @setState(3)

    handleActiveChange: () ->
      if @model.get('active') == true
        @setState(2)

    hideEl: () ->
      @$el.hide()

    fadeOut: (time) ->
      if @$el.is(':visible')
        @$el.stop()
        @$el.fadeOut(time)

    highlight: () ->
      @$el.stop()
      @$el.css({opacity: 1})
      @$el.show()

    fadeIn: (time) ->
      if !@$el.is(':visible')
        @$el.stop()
        @$el.fadeTo(time, .3)

    onRender: () ->
      svg = @model.getSvg()
      @$el.html(svg)
      @$el.attr({'data-model-id': @model.id})
      @setState(0)
