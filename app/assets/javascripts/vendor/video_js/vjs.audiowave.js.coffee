define (require) ->

  WaveSurfer = require('wavesurfer')

  VjsAudioWavePlugin = (options) ->

    class VjsAudioWave

      constructor: (options, player) ->
        @player = player
        @callStack = 0
        @options = options
        @surfer = Object.create(WaveSurfer);
        @ignoreSurferSeek = false

        containerProperties = {
          className: 'vjs-waveform'
          tabIndex: 0
        }
        container = videojs.Component.prototype.createEl(null, containerProperties)
        @container = $(container)

        surferOptions = {
          height: @player.height() - 48
          container: container
          progressColor: '#43B5AE'
          waveColor: '#6d6e71'
          interact: false
        }
        @surfer.init(surferOptions)
        @surfer.load(options.src)

        $(@player.el()).find('.vjs-tech').after(container)

        @setupListeners()
        @player.controlBar.show()

      setupListeners: () ->
        @player.on('timeupdate', (event) => @updateSurferPosition(event))

        # prevent controlbar fadeout
        @player.on('userinactive', (event) => @player.userActive(true))

        @container.on('click', (event) =>
          @requestSeek(event)
        )

      requestSeek: (event) ->
        offsetX = event.offsetX
        width = @container.width()
        percentage = offsetX / width
        duration = @player.duration()
        seconds = duration * percentage
        @player.currentTime(seconds)

      updateSurferPosition: (event) ->
        time = @player.currentTime()
        duration = @player.duration()
        percentage = time / duration
        @surfer.seekTo(percentage)



    return new VjsAudioWave(options, @)

  videojs.plugin('audiowave', VjsAudioWavePlugin)