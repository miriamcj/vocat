define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/player/video_player')

  class VideoPlayerView extends Marionette.ItemView

    template: template
    lock: null

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
      @listenTo(@vent, 'request:play', (data) => @handlePlayRequest(data))
      @listenTo(@vent, 'request:pause', (data) => @handlePauseRequest(data))
      @listenTo(@vent, 'request:resume', (data) => @handleResumeRequest(data))
      @listenTo(@vent, 'request:lock', (data) => @handleLockRequest(data))
      @listenTo(@vent, 'request:unlock', (data) => @handleUnlockRequest(data))

    isLocked: () ->
      @lock != null

    unlockPlayer: () ->
      lock = @lock
      @lock = null
      @player.controls(true)
      @vent.trigger('announce:unlocked', lock)

    # Lock should be {view: aView, seconds: seconds}
    lockPlayer: (lock) ->
      @lock = lock
      @player.controls(false)
      @vent.trigger('announce:locked', @lock)

    checkIfLocked: () ->
      if @isLocked() == true
        @vent.trigger('announce:lock:attempted')
        @lock.view.trigger('lock:attempted')
        result = true
      else
        result = false
      result

    setupPlayerEvents: () ->
      @player.on( 'timeupdate', ()=>
        @announceTimeUpdate()
      )
      @player.on( 'loadedmetadata', () => @handleStatusRequest())
      @player.on( 'progress', () =>
        @vent.trigger('announce:progress', {bufferedPercent: @getBufferedPercent()})
      )
      @player.on( 'play', () =>
        if @checkIfLocked() == true && _.isFunction(@player.pause)
          @player.pause()
          @player.currentTime(@lock.seconds)
        else
          @vent.trigger('announce:play')
      )

    announceTimeUpdate: () ->
      @vent.trigger('announce:time:update', {
        playedPercent: @getPlayedPercent(),
        playedSeconds: @player.currentTime()
      })

    getBufferedPercent: () ->
      @player.bufferedPercent()

    getPlayedPercent: () ->
      if @player
        duration = @player.duration()
        time = @player.currentTime()
        if !time
          time = 0.00
        else
        if duration > 0
          percentage = time / duration
        else
          percentage = 0
      else
        percentage = 0
      percentage

    handleUnlockRequest: () ->
      @unlockPlayer()

    handleLockRequest: (data) ->
      @lockPlayer(data)

    handleStatusRequest: () ->
      @vent.trigger('announce:status', {
        bufferedPercent: @getBufferedPercent()
        playedPercent: @getPlayedPercent()
        playedSeconds: @player.currentTime()
        duration: @player.duration()
      })

    handleResumeRequest: () ->
      if @wasPlaying == true
        @player.play()
        @wasPlaying = false

    handlePlayRequest: () ->
      @player.play()

    handlePauseRequest: () ->
      playing = !@player.paused()
      if playing == true
        @wasPlaying = true
        @player.pause()

    handleTimeUpdateRequest: (data) ->
      # Views can put a lock on the player. If the user tries to update the playback time, the player refuses, and
      # expected the view that holds the lock to do something.
      if @checkIfLocked() == false
        if data.hasOwnProperty('percent')
          duration = @player.duration()
          seconds = duration * data.percent
        else
          seconds = data.seconds
        seconds = seconds
        @player.currentTime(seconds)
        duration = @player.duration()
        @vent.trigger('announce:time:update', {
          playedPercent: seconds / duration,
          playedSeconds: seconds
        })

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
            children: {
              timeDivider: false
              currentTimeDisplay: false
              durationDisplay: false
              remainingTimeDisplay: false
            }
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
