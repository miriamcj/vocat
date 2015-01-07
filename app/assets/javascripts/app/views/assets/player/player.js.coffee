define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/player/player')

  class PlayerView extends Marionette.ItemView

    template: template

    ui: {
      player: '[data-behavior="video-player"]'
      playerContainer: '[data-behavior="player-container"]'
    }

    initialize: (options) ->
      @vent = options.vent

    onShow: () ->
      @setupPlayer()
      @setupPlayerEvents()
      @setupListeners()

    setupListeners: () ->
      @listenTo(@vent, 'request:time:update', (data) => @handleTimeUpdateRequest(data))
      @listenTo(@vent, 'request:status', (data) => @handleStatusRequest())

    setupPlayerEvents: () ->
      @player.on( 'timeupdate', ()=>
        @announceTimeUpdate()
      )
      @player.on( 'loadedmetadata', () => @handleStatusRequest())
      @player.on( 'progress', ()=>
        @vent.trigger('announce:progress', {bufferedPercent: @getBufferedPercent()})
      )

    announceTimeUpdate: () ->
      @vent.trigger('announce:time:update', {
        playedPercent: @getPlayedPercent(),
        playedSeconds: @player.currentTime().toFixed(2)
      })

    getBufferedPercent: () ->
      @player.bufferedPercent().toFixed(2)

    getPlayedPercent: () ->
      duration = @player.duration()
      if duration > 0
        percentage = @player.currentTime().toFixed(2) / duration
      else
        percentage = 0
      percentage

    handleStatusRequest: () ->
      @vent.trigger('announce:status', {
        bufferedPercent: @getBufferedPercent()
        playedPercent: @getPlayedPercent()
        playedSeconds: @player.currentTime().toFixed(2)
        duration: @player.duration()
      })

    handleTimeUpdateRequest: (data) ->
      if data.hasOwnProperty('percent')
        duration = @player.duration()
        seconds = duration * data.percent
      else
        seconds = data.seconds
      @player.currentTime(seconds)
      setTimeout(() =>
        @announceTimeUpdate()
      , 50)

    resizePlayer: (aspectRatio) ->
      width = @ui.playerContainer.outerWidth()
      height = width / 1.77
      @player.width(width).height(height)

    setupPlayer: () ->
      domTarget = @ui.player[0]
      options = {
        techOrder: @model.techOrder()
        width: 'auto'
        height: 'auto'
        children: {
          controlBar: {
            progressControl: {
              seekBar: {
                loadProgressBar: false
                playProgressBar: false
                seekHandle: false
              }
            }
          }
        }
      }

      @player = videojs(domTarget, options, () ->
      )

      @resizePlayer()