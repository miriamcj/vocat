/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import 'jquery_ui';
import template from 'hbs!templates/assets/annotator/progress_bar';
import childView from 'views/assets/annotator/progress_bar_annotation';

export default class VideoProgressBarView extends Marionette.CompositeView {
  constructor() {

    this.template = template;
    this.wasPlaying = false;
    this.seeking = false;

    this.ui = {
      played: '[data-behavior="played"]',
      buffered: '[data-behavior="buffered"]',
      marks: '[data-behavior="marks"]',
      scrubber: '[data-behavior="scrubber"]',
      trackOverlay: '[data-behavior="track-overlay"]',
      timeElapsed: '[data-behavior="time-elapsed"]'
    };

    this.childViewContainer = '[data-behavior="marks"]';
    this.childView = childView;

    this.events = {
      'click @ui.trackOverlay': 'onTrackOverlayClicked'
    };
  }
  childViewOptions() {
    return {
    vent: this.vent
    };
  }

  onTrackOverlayClicked(e) {
    const trackOffset = this.ui.trackOverlay.offset();
    const trackWidth = this.ui.trackOverlay.outerWidth();
    const offsetXClick = e.pageX - trackOffset.left;
    const offsetYClick = e.pageY - trackOffset.top;
    const percent = offsetXClick / trackWidth;
    return this.vent.trigger('request:time:update', {percent});
  }

  // BufferedPercent is an int between 0 and 1
  updateBufferedPercentUi(bufferedPercent) {
    return this.ui.buffered.outerWidth(`${bufferedPercent * 100}%`);
  }

  // PlayedPercent is an int between 0 and 1
  updatePlayedPercentUi(playedPercent) {
    const p = `${playedPercent * 100}%`;
    this.ui.played.outerWidth(p);
    return this.ui.scrubber.css('left', p);
  }

  secondsToString(seconds) {
    let minutes = Math.floor(seconds / 60);
    seconds = Math.floor(seconds - (minutes * 60));
    const minuteZeroes = (2 - minutes.toString().length) + 1;
    minutes = Array(+((minuteZeroes > 0) && minuteZeroes)).join("0") + minutes;
    const secondZeroes = (2 - seconds.toString().length) + 1;
    seconds = Array(+((secondZeroes > 0) && secondZeroes)).join("0") + seconds;
    return `${minutes}:${seconds}`;
  }

  updateTimeElapsedUi(playedSeconds, duration) {
    return this.ui.timeElapsed.html(this.secondsToString(playedSeconds));
  }

  setupListeners() {
    this.listenTo(this.vent, 'announce:progress', function(data) {
      return this.updateBufferedPercentUi(data.bufferedPercent);
    });
    this.listenTo(this.vent, 'announce:time:update', data => {
      this.updatePlayedPercentUi(data.playedPercent);
      return this.updateTimeElapsedUi(data.playedSeconds);
    });
    this.listenTo(this.vent, 'announce:locked', data => {
      return this.lockDragger();
    });
    return this.listenTo(this.vent, 'announce:unlocked', data => {
      return this.unlockDragger();
    });
  }

  onAddChild() {
    return this.children.call('updatePosition');
  }

  synchronizeWithPlayer() {
    this.listenToOnce(this.vent, 'announce:status', data => {
      return this.updatePlayedPercentUi(data.playedPercent);
    });
    return this.vent.trigger('request:status', {});
  }

  handleScrubberDrag(event, ui) {
    const trackOffset = this.ui.trackOverlay.offset();
    const trackWidth = this.ui.trackOverlay.outerWidth();
    const offsetXClick = ui.position.left;
    const percent = offsetXClick / trackWidth;
    return this.vent.trigger('request:time:update', {percent});
  }

  handleScrubberStartDrag(event, ui) {
    this.seeking = true;
    return this.vent.trigger('request:pause', {});
  }

  handleScrubberStopDrag(event, ui) {
    this.seeking = false;
    return this.vent.trigger('request:resume', {});
  }

  lockDragger() {
    return this.ui.scrubber.draggable('disable');
  }

  unlockDragger() {
    return this.ui.scrubber.draggable('enable');
  }

  onRender() {
    const config = {
      axis: "x",
      containment: "parent",
      drag: (event, ui) => this.handleScrubberDrag(event, ui),
      start: (event, ui) => this.handleScrubberStartDrag(event, ui),
      stop: (event, ui) => this.handleScrubberStopDrag(event, ui)
    };
    this.ui.scrubber.draggable(config);
    return this.synchronizeWithPlayer();
  }

  initialize(options) {
    this.vent = options.vent;
    return this.setupListeners();
  }
};
