define (require) ->

  Marionette = require('marionette')

  class MockCanvasView extends Marionette.ItemView

    template: false

    initialize: (options) ->
      @vent = options.vent
      @collection = @model.annotations()
      @setupListeners()

    setupListeners: () ->
      @listenTo(@vent, 'request:canvas', @announceCanvas, @)

    announceCanvas: () ->
      console.log 'heard it'
      json = null
      svg = null
      @vent.trigger('announce:canvas', JSON.stringify({json: json, svg: svg}))
