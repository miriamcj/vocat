import Marionette from 'backbone.marionette';
import { $ } from "jquery";
import { debounce, isFunction } from "lodash";
import template from 'templates/assets/player/video_player.hbs';
import PlayerAnnotations from 'views/assets/player/player_annotations';
let vjsAnnotations = require('video_js/vjs.annotations');
vjsAnnotations = require('video_js/vjs.rewind');
const vjsAudioWave = require('video_js/vjs.audiowave');

export default class VideoPlayerView extends Marionette.ItemView {
  constructor(...args) {
    super(...args);
    this.resizePlayer = this.resizePlayer.bind(this);
    this.template = template;
    this.lock = null;

    this.ui = {
      player: '[data-behavior="video-player"]',
      playerContainer: '[data-behavior="player-container"]'
    };

    this.events = {
    };

    this.callbacks = [];

    this.announceTimeUpdate = debounce(function() {
      const time = this.player.currentTime();
      const percent = this.getPlayedPercent();
      this.vent.trigger('announce:time:update', {
        playedPercent: percent,
        playedSeconds: time
      });
      return this.processCallbacks(time);
    }, 10, true);
  }

  initialize(options) {
    return this.vent = options.vent;
  }

  onShow() {
    this.setupPlayer();
    this.setupPlayerEvents();
    return this.setupListeners();
  }

  setupListeners() {
    this.listenTo(this.vent, 'request:annotation:show', data => this.handleAnnotationShow(data));
    this.listenTo(this.vent, 'request:annotation:hide', data => this.handleAnnotationHide(data));
    this.listenTo(this.vent, 'request:time:update', data => this.handleTimeUpdateRequest(data));
    this.listenTo(this.vent, 'request:status', data => this.handleStatusRequest());
    this.listenTo(this.vent, 'request:play', data => this.handlePlayRequest(data));
    this.listenTo(this.vent, 'request:toggle', data => this.handlePlayToggleRequest(data));
    this.listenTo(this.vent, 'request:pause', data => this.handlePauseRequest(data));
    this.listenTo(this.vent, 'request:resume', data => this.handleResumeRequest(data));
    this.listenTo(this.vent, 'request:lock', data => this.handleLockRequest(data));
    this.listenTo(this.vent, 'request:unlock', data => this.handleUnlockRequest(data));
    this.listenTo(this.vent, 'announce:annotator:input:start', data => this.handlePauseRequest(data));
    this.listenTo(this.vent, 'announce:canvas:enabled', data => this.handleCanvasEnabled());
    this.listenTo(this.vent, 'announce:canvas:disabled', data => this.handleCanvasDisabled());
    return $(window).on('resize', this.resizePlayer);
  }

  handleCanvasEnabled() {
    return this.player.addClass('canvas-enabled');
  }

  handleCanvasDisabled() {
    return this.player.removeClass('canvas-enabled');
  }

  shiftFocusToInput() {
    return $('.annotation-input').focus();
  }

  isLocked() {
    return this.lock !== null;
  }

  unlockPlayer() {
    const { lock } = this;
    this.lock = null;
    this.player.controls(true);
    return this.vent.trigger('announce:unlocked', lock);
  }

  // Lock should be {view: aView, seconds: seconds}
  lockPlayer(lock) {
    this.lock = lock;
    this.player.controls(false);
    return this.vent.trigger('announce:locked', this.lock);
  }

  checkIfLocked(seconds = null) {
    let result;
    if (this.isLocked() === true) {
      this.vent.trigger('announce:lock:attempted', seconds);
      this.lock.view.trigger('lock:attempted', seconds);
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  setupPlayerEvents() {
    this.player.on('timeupdate', ()=> {
      return this.announceTimeUpdate();
    });
    this.player.on('loadedmetadata', () => {
      this.vent.trigger('announce:loaded', this.getStatusHash());
      return this.handleStatusRequest();
    });
    this.player.on('progress', () => {
      return this.vent.trigger('announce:progress', {bufferedPercent: this.getBufferedPercent()});
    });
    return this.player.on('play', () => {
      if ((this.checkIfLocked() === true) && isFunction(this.player.pause)) {
        this.player.pause();
        return this.player.currentTime(this.lock.seconds);
      } else {
        this.handleStatusRequest();
        this.vent.trigger('announce:play');
        return this.shiftFocusToInput();
      }
    });
  }

  getBufferedPercent() {
    return this.player.bufferedPercent();
  }

  processCallbacks(second) {
    if (this.callbacks.length > 0) {
      return this.callbacks.forEach((callbackDetails, index) => {
        if (callbackDetails.seconds <= Math.ceil(second)) {
          callbackDetails.callback.apply(callbackDetails.scope);
          return this.callbacks.splice(index, 1);
        }
      });
    }
  }

  getPlayedPercent() {
    let percentage;
    if (this.player) {
      const duration = this.player.duration();
      let time = this.player.currentTime();
      if (!time) {
        time = 0.00;
      }
      else {}
      if (duration > 0) {
        percentage = time / duration;
      } else {
        percentage = 0;
      }
    } else {
      percentage = 0;
    }
    return percentage;
  }

  handleUnlockRequest() {
    return this.unlockPlayer();
  }

  handleLockRequest(data) {
    return this.lockPlayer(data);
  }

  getStatusHash() {
    return {
    bufferedPercent: this.getBufferedPercent(),
    playedPercent: this.getPlayedPercent(),
    playedSeconds: this.player.currentTime(),
    duration: this.player.duration()
    };
  }

  handleStatusRequest() {
    return this.vent.trigger('announce:status', this.getStatusHash());
  }

  handleAnnotationShow(data) {
    return this.player.trigger({
      type: 'annotation:show',
      annotation: data
    });
  }

  handleAnnotationHide(data) {
    return this.player.trigger({
      type: 'annotation:hide'
    });
  }

  handlePlaybackToggleRequest() {
    if (this.player.paused()) {
      return this.handlePlayRequest();
    } else {
      return this.handlePauseRequest();
    }
  }

  handleResumeRequest() {
    if (this.wasPlaying === true) {
      this.player.play();
      return this.wasPlaying = false;
    }
  }

  handlePlayRequest() {
    return this.player.play();
  }

  handlePauseRequest() {
    const playing = !this.player.paused();
    if (playing === true) {
      this.wasPlaying = true;
      this.player.pause();
    }
    return this.vent.trigger('announce:paused', this.getStatusHash());
  }

  addTimeBasedCallback(seconds, callback, callbackScope) {
    return this.callbacks.push({
      seconds,
      callback,
      scope: callbackScope
    });
  }

  handleTimeUpdateRequest(data) {
    let seconds;
    if (data.hasOwnProperty('percent')) {
      const duration = this.player.duration();
      seconds = duration * data.percent;
    } else {
      ({ seconds } = data);
    }
    seconds = seconds;
    if (data.hasOwnProperty('callback') && isFunction(data.callback)) {
      this.addTimeBasedCallback(seconds, data.callback, data.callbackScope);
    }

    // Views can put a lock on the player. If the user tries to update the playback time, the player refuses, and
    // expected the view that holds the lock to do something.
    if (this.checkIfLocked(seconds) === false) {

      // Anytime a time update is requested, we will stop the annotation editing
      // mode. There is a subtle difference here between stopping on request and stopping
      // on actual time update. It's user intent that we want to capture, not the time update
      // itself.
      this.vent.trigger('request:annotator:input:stop');
      this.player.currentTime(seconds);

      // Youtube videos don't always announce the correct time after an update, so we delay and then announce again.
      if (this.model.get('type') === 'Asset::Youtube') {
        return setTimeout(() => {
          return this.announceTimeUpdate();
        }
        ,500);
      }
    }
  }

  getPlayerDimensions() {
    let height, width;
    if (this.model.get('family') === 'audio') {
      width = this.ui.playerContainer.outerWidth();
      height = width / 2.5;
    } else {
      width = this.ui.playerContainer.outerWidth();
      height = width / 1.77;
    }
    return {width, height};
  }

  onDestroy() {
    this.player.dispose();
    return $(window).off('resize', this.resizePlayer);
  }

  resizePlayer() {
    const dimensions = this.getPlayerDimensions();
    return this.player.width(dimensions.width).height(dimensions.height);
  }

  insertAnnotationsStageView() {
    const container = document.createElement('div');
    container.id = 'vjs-annotation-overlay';
    this.stageView = new PlayerAnnotations({model: this.model, vent: this.vent});
    this.stageView.render();
    $(container).append(this.stageView.el);
    return $(this.player.el()).find('.vjs-poster').before(container);
  }

  setupPlayer() {
    const dimensions = this.getPlayerDimensions();
    const domTarget = this.ui.player[0];

    const options = {
      techOrder: this.model.techOrder(),
      width: dimensions.width,
      height: dimensions.height,
      plugins: {
        annotations: {
          vent: this.vent,
          collection: this.model.annotations()
        }
      },
      controlBar: {
        durationDisplay: true
      }
    };
    if (this.model.get('type') === 'Asset::Vimeo') {
      const locations = this.model.get('locations');
      options.src = locations.url;
    }

    if (this.model.get('family') === 'audio') {
      options.controlBar['fullscreenToggle'] = false;
      options.plugins = {
        audiowave: {
          src: this.model.get('locations').mp3 || this.model.get('locations').mp4,
          msDisplayMax: 10,
          waveColor: "grey",
          progressColor: "black",
          cursorColor: "black",
          hideScrollbar: true
        }
      };
    }

    this.player = videojs(domTarget, options, function() {});
    this.player.rewind({});

    if (this.model.allowsVisibleAnnotation()) { this.insertAnnotationsStageView(); }
    return this.resizePlayer();
  }
}
