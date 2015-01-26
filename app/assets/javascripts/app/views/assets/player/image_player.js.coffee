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

    setupListeners: () ->
      @listenTo(@vent, 'request:status', (data) => @handleStatusRequest())

    handleStatusRequest: () ->
      @vent.trigger('announce:status', {
        bufferedPercent: 0
        playedPercent: 0
        playedSeconds: 0
        duration: 0
      })

