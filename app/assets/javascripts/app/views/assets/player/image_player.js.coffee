define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/player/image_displayer')
  PlayerAnnotations = require('views/assets/player/player_annotations')

  class ImageDisplayerView extends Marionette.LayoutView

    template: template
    regions: {
      annotationsContainer: '[data-region="annotation-container"]'
    }

    ui: {
      annotationContainer: '[data-behavior="annotation-container"]'
    }

    initialize: (options) ->
      @vent = options.vent

    onShow: () ->
      @setupListeners()
      @annotationsContainer.show(new PlayerAnnotations({model: @model, vent: @vent}))

    handleTimeUpdate: (data) ->
      if data.hasOwnProperty('callback') && _.isFunction(data.callback)
        data.callback.apply(data.scope)

    setupListeners: () ->
      @listenTo(@vent, 'request:status', (data) => @handleStatusRequest())
      @listenTo(@vent, 'request:time:update', @handleTimeUpdate, @)
      @listenTo(@vent, 'request:pause', (data) => @handlePauseRequest())
      @listenTo(@vent, 'announce:annotator:input:start', (data) => @handlePauseRequest())
      @listenTo(@vent, 'all', (e) -> console.log e)

    getStatus: () ->
      {
      bufferedPercent: 0
      playedPercent: 0
      playedSeconds: 0
      duration: 0
      }

    handlePauseRequest: () ->
      @vent.trigger('announce:paused', @getStatus())


    handleStatusRequest: () ->
      @vent.trigger('announce:status', @getStatus())

