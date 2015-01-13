define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/player/image_displayer')

  class ImageDisplayerView extends Marionette.ItemView

    template: template

    initialize: (options) ->
      @vent = options.vent
      console.log @model.attributes

    onShow: () ->
      @setupListeners()

    setupListeners: () ->
      @listenTo(@vent, 'request:status', (data) => @handleStatusRequest())

    handleStatusRequest: () ->
      @vent.trigger('announce:status', {
        bufferedPercent: 0
        playedPercent: 0
        playedSeconds: 0
        duration: 0
      })
