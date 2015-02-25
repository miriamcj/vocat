define (require) ->

  Marionette = require('marionette')
#  vjsWavesurfer = require('vendor/video_js/vjs.wavesurfer')
  vjsAudioWave = require('vendor/video_js/vjs.audiowave')
  template = require('hbs!templates/assets/player/video_player')
  PlayerAnnotations = require('views/assets/player/player_annotations')

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
      @listenTo(@vent, 'request:annotation:show', (data) => @handleAnnotationShow(data))
      @listenTo(@vent, 'request:annotation:hide', (data) => @handleAnnotationHide(data))
      @listenTo(@vent, 'request:time:update', (data) => @handleTimeUpdateRequest(data))
      @listenTo(@vent, 'request:status', (data) => @handleStatusRequest())
      @listenTo(@vent, 'request:play', (data) => @handlePlayRequest(data))
      @listenTo(@vent, 'request:toggle', (data) => @handlePlayToggleRequest(data))
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

    checkIfLocked: (seconds = null) ->
      if @isLocked() == true
        @vent.trigger('announce:lock:attempted', seconds)
        @lock.view.trigger('lock:attempted', seconds)
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

    handleAnnotationShow: (data) ->
      @player.trigger({
        type: 'annotation:show'
        annotation: data
      })

    handleAnnotationHide: (data) ->
      @player.trigger({
        type: 'annotation:hide'
      })

    handlePlaybackToggleRequest: () ->
      if @player.paused()
        @handlePlayRequest()
      else
        @handlePauseRequest()

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
      if data.hasOwnProperty('percent')
        duration = @player.duration()
        seconds = duration * data.percent
      else
        seconds = data.seconds
      seconds = seconds

      # Views can put a lock on the player. If the user tries to update the playback time, the player refuses, and
      # expected the view that holds the lock to do something.
      if @checkIfLocked(seconds) == false
        @player.currentTime(seconds)
        duration = @player.duration()
        @vent.trigger('announce:time:update', {
          playedPercent: seconds / duration,
          playedSeconds: seconds
        })

    getPlayerDimensions: () ->
      width = @ui.playerContainer.outerWidth()
      height = width / 1.77
      {width: width, height: height}

    resizePlayer: (aspectRatio) ->
      dimensions = @getPlayerDimensions()
      @player.width(dimensions.width).height(dimensions.height)

    insertAnnotationsStageView: () ->
      container = document.createElement('div');
      container.id = 'vjs-annotation-overlay';
      @stageView = new PlayerAnnotations({model: @model, vent: @vent})
      @stageView.render()
      $(container).append(@stageView.el)
      $(@player.el()).find('.vjs-poster').before(container)

    setupPlayer: () ->
      dimensions = @getPlayerDimensions()
      domTarget = @ui.player[0]

      options = {
        techOrder: @model.techOrder()
        width: dimensions.width
        height: dimensions.height
        plugins: {
        }
        children: {
          controlBar: {
            children: {
              timeDivider: false
              currentTimeDisplay: false
              durationDisplay: true
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
      if @model.get('type') == 'Asset::Vimeo'
        locations = @model.get('locations')
        options.src = locations.url

      if @model.get('family') == 'audio'
        options.children.controlBar.children['fullscreenToggle'] = false
        options.plugins = {
          audiowave: {
            src: @model.get('locations').mp3,
            msDisplayMax: 10,
            waveColor: "grey",
            progressColor: "black",
            cursorColor: "black",
            hideScrollbar: true
          }
        }

      @player = videojs(domTarget, options, () -> )

      @insertAnnotationsStageView() if @model.allowsVisibleAnnotation()
      @resizePlayer()
