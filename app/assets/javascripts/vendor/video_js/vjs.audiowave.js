define(function(require) {

  const WaveSurfer = require('wavesurfer');
  const videojs = require('video_js/video.js');

  const VjsAudioWavePlugin = function(options) {

    class VjsAudioWave {

      constructor(options, player) {
        this.player = player;
        this.callStack = 0;
        this.options = options;
        this.surfer = Object.create(WaveSurfer);
        this.ignoreSurferSeek = false;

        const containerProperties = {
          className: 'vjs-waveform',
          tabIndex: 0
        };
        const container = videojs.createEl("div", containerProperties);
        this.container = $(container);

        const surferOptions = {
          height: this.player.height() - 48,
          container,
          progressColor: '#43B5AE',
          waveColor: '#6d6e71',
          interact: false
        };
        this.surfer.init(surferOptions);
        this.surfer.load(options.src);

        $(this.player.el()).find('.vjs-tech').after(container);

        this.setupListeners();
      }

      setupListeners() {
        this.player.on('timeupdate', event => this.updateSurferPosition(event));

        // prevent controlbar fadeout
        this.player.on('userinactive', event => this.player.userActive(true));

        return this.container.on('click', event => {
          return this.requestSeek(event);
        });
      }

      requestSeek(event) {
        const { offsetX } = event;
        const width = this.container.width();
        const percentage = offsetX / width;
        const duration = this.player.duration();
        const seconds = duration * percentage;
        return this.player.currentTime(seconds);
      }

      updateSurferPosition(event) {
        const time = this.player.currentTime();
        const duration = this.player.duration();
        const percentage = time / duration;
        return this.surfer.seekTo(percentage);
      }
    }



    return new VjsAudioWave(options, this);
  };

  return videojs.plugin('audiowave', VjsAudioWavePlugin);
});
