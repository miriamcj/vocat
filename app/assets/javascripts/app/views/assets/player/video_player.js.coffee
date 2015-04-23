define (require) ->
  Marionette = require('marionette')
  vjsAnnotations = require('vendor/video_js/vjs.annotations')
  vjsAnnotations = require('vendor/video_js/vjs.rewind')
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

    callbacks: []

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
      @listenTo(@vent, 'announce:annotator:input:start', (data) => @handlePauseRequest(data))
      @listenTo(@vent, 'announce:canvas:enabled', (data) => @handleCanvasEnabled())
      @listenTo(@vent, 'announce:canvas:disabled', (data) => @handleCanvasDisabled())
      $(window).on('resize', @resizePlayer)

    handleCanvasEnabled: () ->
      @player.addClass('canvas-enabled')

    handleCanvasDisabled: () ->
      @player.removeClass('canvas-enabled')

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
      @player.on('timeupdate', ()=>
        @announceTimeUpdate()
      )
      @player.on('loadedmetadata', () =>
        @vent.trigger('announce:loaded', @getStatusHash())
        @handleStatusRequest()
      )
      @player.on('progress', () =>
        @vent.trigger('announce:progress', {bufferedPercent: @getBufferedPercent()})
      )
      @player.on('play', () =>
        if @checkIfLocked() == true && _.isFunction(@player.pause)
          @player.pause()
          @player.currentTime(@lock.seconds)
        else
          @handleStatusRequest()
          @vent.trigger('announce:play')
      )

    getBufferedPercent: () ->
      @player.bufferedPercent()

    announceTimeUpdate: _.debounce(
      () ->
        time = @player.currentTime()
        percent = @getPlayedPercent()
        @vent.trigger('announce:time:update', {
          playedPercent: percent
          playedSeconds: time
        })
        @processCallbacks(time)
    , 10, true)

    processCallbacks: (second) ->
      if @callbacks.length > 0
        _.each(@callbacks, (callbackDetails, index) =>
          if callbackDetails.seconds <= Math.ceil(second)
            callbackDetails.callback.apply(callbackDetails.scope)
            @callbacks.splice(index, 1)
        )

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

    getStatusHash: () ->
      {
      bufferedPercent: @getBufferedPercent()
      playedPercent: @getPlayedPercent()
      playedSeconds: @player.currentTime()
      duration: @player.duration()
      }

    handleStatusRequest: () ->
      @vent.trigger('announce:status', @getStatusHash())

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
      @vent.trigger('announce:paused', @getStatusHash())

    addTimeBasedCallback: (seconds, callback, callbackScope) ->
      @callbacks.push {
        seconds: seconds
        callback: callback
        scope: callbackScope
      }

    handleTimeUpdateRequest: (data) ->
      if data.hasOwnProperty('percent')
        duration = @player.duration()
        seconds = duration * data.percent
      else
        seconds = data.seconds
      seconds = seconds
      if data.hasOwnProperty('callback') && _.isFunction(data.callback)
        @addTimeBasedCallback(seconds, data.callback, data.callbackScope)

      # Views can put a lock on the player. If the user tries to update the playback time, the player refuses, and
      # expected the view that holds the lock to do something.
      if @checkIfLocked(seconds) == false

        # Anytime a time update is requested, we will stop the annotation editing
        # mode. There is a subtle difference here between stopping on request and stopping
        # on actual time update. It's user intent that we want to capture, not the time update
        # itself.
        @vent.trigger('request:annotator:input:stop')
        @player.currentTime(seconds)

        # Youtube videos don't always announce the correct time after an update, so we delay and then announce again.
        if @model.get('type') == 'Asset::Youtube'
          setTimeout(() =>
            @announceTimeUpdate()
          ,500)

    getPlayerDimensions: () ->
      if @model.get('family') == 'audio'
        width = @ui.playerContainer.outerWidth()
        height = width / 2.5
      else
        width = @ui.playerContainer.outerWidth()
        height = width / 1.77
      {width: width, height: height}

    onDestroy: () ->
      @player.dispose()
      $(window).off('resize', @resizePlayer)

    resizePlayer: () =>
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
          annotations: {
            vent: @vent
            collection: @model.annotations()
          }
          rewind: {}
        }
        children: {
          controlBar: {
            children: {
              durationDisplay: true
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
            src: @model.get('locations').mp3 || @model.get('locations').mp4,
            msDisplayMax: 10,
            waveColor: "grey",
            progressColor: "black",
            cursorColor: "black",
            hideScrollbar: true
          }
        }

      @player = videojs(domTarget, options, () ->)

      @insertAnnotationsStageView() if @model.allowsVisibleAnnotation()
      @resizePlayer()
