/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import { template } from "lodash";

export default class PlayerAnnotationItem extends Marionette.ItemView {
  constructor() {

    this.template = template('');
    this.tagName = 'li';

    this.fadeInBeforeAnnotationTime = .75;
    this.fadeOutAfterAnnotationTime = .1;
    this.highlightBeforeAnnotationTime = .25;
    this.visibilityTriggers = {
      beforeShow: null,
      fadeIn: null,
      highlight: null,
      fadeOut: null,
      afterShow: null
    };

    // null = unset, 0 = beforeShow, 1 = fadeIn, 2 = highlight, 3 = fadeOut, 4 = afterShow
    this.state = null;

    this.assetHasDuration = false;
    this.animating = false;
    this.annotationTime = null;
  }

  canTransitionTo(state) {
    if (this.state !== state) {
      return true;
    } else {
      return false;
    }
  }

  updateState(state) {
    this.state = state;
    switch (state) {
      case 0:
        return this.hideEl();
      case 1:
        return this.fadeIn(500);
      case 2:
        return this.highlight();
      case 3:
        return this.fadeOut(250);
      case 4:
        return this.fadeOut(0);
    }
  }

  setState(state) {
    if (this.canTransitionTo(state)) {
      return this.updateState(state);
    }
  }

  updateVisibility(data) {
    if (this.assetHasDuration) {
      const time = data.playedSeconds;
      if (time < this.visibilityTriggers['beforeShow']) { return this.setState(0); }
      if (time > this.visibilityTriggers['afterShow']) { return this.setState(4); }
      if (time > this.visibilityTriggers['fadeOut']) { return this.setState(3); }
      if (time > this.visibilityTriggers['highlight']) { return this.setState(2); }
      if (time > this.visibilityTriggers['fadeIn']) { return this.setState(1); }
    } else {
      return this.handleActiveChange();
    }
  }

  initialize(options) {
    this.vent = options.vent;
    this.assetHasDuration = options.assetHasDuration;
    this.annotationTime = this.model.get('seconds_timecode');
    this.updateVisibilityTriggers();
    return this.setupListeners();
  }

  updateVisibilityTriggers() {
    const annotationTime = this.model.get('seconds_timecode');
    this.visibilityTriggers = {};
    this.visibilityTriggers['beforeShow'] = annotationTime - this.fadeInBeforeAnnotationTime;
    this.visibilityTriggers['fadeIn'] = annotationTime - this.fadeInBeforeAnnotationTime;
    this.visibilityTriggers['highlight'] = annotationTime - this.highlightBeforeAnnotationTime;
    this.visibilityTriggers['fadeOut'] = annotationTime + this.fadeOutAfterAnnotationTime;
    return this.visibilityTriggers['afterShow'] = annotationTime + this.fadeOutAfterAnnotationTime + 250;
  }

  setupListeners() {
    this.listenTo(this.vent, 'announce:time:update', this.updateVisibility, this);
    this.listenTo(this.vent, 'announce:status', this.updateVisibility, this);
    this.listenTo(this.vent, 'announce:annotator:input:start', this.concealAnnotation, this);

    this.listenTo(this.model, 'change:seconds_timecode', this.updateVisibilityTriggers, this);
    this.listenTo(this.model, 'change:canvas', this.render, this);
    if (!this.assetHasDuration) { return this.listenTo(this.model, 'change:active', this.handleActiveChange, this); }
  }

  concealAnnotation() {
    return this.setState(3);
  }

  handleActiveChange() {
    if (this.model.get('active') === true) {
      return this.setState(2);
    } else {
      return this.setState(0);
    }
  }

  hideEl() {
    return this.$el.hide();
  }

  fadeOut(time) {
    if (this.$el.is(':visible')) {
      this.$el.stop();
      return this.$el.fadeOut(time);
    }
  }

  highlight() {
    this.$el.stop();
    this.$el.css({opacity: 1});
    return this.$el.show();
  }

  fadeIn(time) {
    if (!this.$el.is(':visible')) {
      this.$el.stop();
      return this.$el.fadeTo(time, .3);
    }
  }

  onRender() {
    const svg = this.model.getSvg();
    this.$el.html(svg);
    this.$el.attr({'data-model-id': this.model.id});
    return this.setState(0);
  }
}
