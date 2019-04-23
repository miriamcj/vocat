/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import { isNumber, isNaN } from "lodash";
const jqueryUI = require("jquery-ui");
import template from 'templates/submission/evaluations/score_slider.hbs';

export default class ScoreSlider extends Marionette.ItemView {
  constructor() {

    this.template = template;
    this.baselineSnapDuration = 500;
    this.lowShim = 4;
    this.highShim = 4;
    this.tagName = 'li';

    this.events = {
      'drag @ui.grabber': 'onDrag',
      'mousedown @ui.grabber': 'onGrabberMouseDown',
      'dragstop @ui.grabber': 'onDragStop',
      'click @ui.track': 'onTrackClick',
      'mouseenter @ui.grabber': 'showPlacard',
      'mouseout @ui.grabber': 'hidePlacard'
    };

    this.ui = {
      grabber: '[data-behavior="range-grabber"]',
      fill: '[data-behavior="range-fill"]',
      track: '[data-behavior="range-track"]',
      score: '[data-behavior="score"]',
      placardTitle: '[data-behavior="placard-header"]',
      placardContent: '[data-behavior="placard-content"]',
      placard: '[data-behavior="placard"]'
    };
  }

  showPlacard(e) {
    return this.ui.placard.fadeIn();
  }

  forceHidePlacard() {
    return this.ui.placard.hide();
  }

  hidePlacard(e) {
    if (!this.ui.grabber.hasClass('ui-draggable-dragging')) {
      return this.ui.placard.hide();
    }
  }

  currentPosition() {
    return this.ui.grabber.position().left;
  }

  translatePositionToSnapPosition(position) {
    let score = this.translatePositionToScore(position);
    if (score < this.model.get('low')) {
      score = this.model.get('low');
    }
    position = this.translateScoreToPosition(score);
    return position;
  }

  translateScoreToPercentage(score) {
    return (parseInt(score) / parseInt(this.model.get('high'))) * 100;
  }

  translatePercentageToScore(percentage) {
    return Math.round(parseInt(this.model.get('high')) * (percentage / 100));
  }

  translateScoreToPosition(score) {
    const percentage = (score / this.model.get('high')) * 100;
    return this.translatePercentageToPosition(percentage);
  }

  translatePositionToPercentage(position) {
    const b = this.relativeBoundaryBox();
    const low = b[0];
    const high = b[2];
    return ( (position - low) / (high - low) ) * 100;
  }

  translatePositionToScore(position) {
    const percentage = this.translatePositionToPercentage(position);
    return this.translatePercentageToScore(percentage);
  }

  translatePercentageToPosition(percentage) {
    const b = this.relativeBoundaryBox();
    const low = b[0];
    const high = b[2];
    const distance = b[2] - b[0];
    return b[0] + (distance * (percentage / 100));
  }

  trackWidth() {
    const b = this.boundaryBox();
    return b[2] - b[0];
  }

  relativeBoundaryBox() {
    let out;
    const b = this.absoluteBoundaryBox();
    const offset = this.ui.track.offset();
    return out = [(b[0] - offset.left) + this.lowShim, 0, (b[2] - offset.left) + this.highShim, b[3]];
  }

  absoluteBoundaryBox() {
    let boundary;
    const offset = this.ui.track.offset();
    const grabberOffset = (this.ui.grabber.outerWidth() * .5) - 4; // 4px is half the width of one tick
    const startCoord = offset.left - grabberOffset;
    const endCoord = (offset.left + this.ui.track.outerWidth()) - grabberOffset;
    return boundary = [startCoord, 0, endCoord, 0];
  }

  updateScore(score) {
    return this.ui.score.html(score);
  }

  updatePlacard(score) {
    if (isNumber(score) && !isNaN(score)) {
      const range = this.rubric.getRangeForScore(score);
      if (range != null) {
        const desc = this.rubric.getCellDescription(this.model.id, range.id);
        this.ui.placardContent.html(desc);
        return this.ui.placardTitle.html(range.get('name'));
      }
    }
  }

  // This is the main method for setting the current score.
  updateBarAndGrabberPosition(position, animate, updateModel) {
    if (animate == null) { animate = false; }
    if (updateModel == null) { updateModel = true; }
    this.updateFillPosition(position, animate, updateModel);
    return this.updateGrabberPosition(position, animate, updateModel);
  }

  updateGrabberPosition(position, animate, updateModel) {
    if (animate == null) { animate = false; }
    if (updateModel == null) { updateModel = true; }
    if (animate === true) {
      this.forceHidePlacard();
      this.ui.grabber.animate({left: `${position}px`}, 250);
    } else {
      this.ui.grabber.css({left: `${position}px`});
    }
    if (updateModel) { return this.updateModelFromPosition(position); }
  }

  updateModelFromPosition(position) {
    this.model.set('score', this.translatePositionToScore(position));
    this.model.set('percentage', this.translatePositionToPercentage(position));
    return this.trigger('updated');
  }

  updateFillPosition(position, animate, updateModel) {
    if (animate == null) { animate = false; }
    if (updateModel == null) { updateModel = true; }
    const score = this.translatePositionToScore(position);
    this.updateScore(score);
    this.updatePlacard(score);
    position = position + 5;
    if (animate === true) {
      this.forceHidePlacard();
      return this.ui.fill.animate({width: `${position}px`}, 250);
    } else {
      return this.ui.fill.width(position);
    }
  }

  onDrag(event, ui) {
    return this.updateFillPosition(ui.position.left);
  }

  onTrackClick(event) {
    const clickLoc = event.pageX;
    const adjustedLoc = clickLoc - this.ui.track.offset().left;
    const snappedLoc = this.translatePositionToSnapPosition(adjustedLoc);
    return this.updateBarAndGrabberPosition(snappedLoc, true);
  }

  onDragStop() {
    const newPosition = this.translatePositionToSnapPosition(this.currentPosition());
    return this.updateBarAndGrabberPosition(newPosition, true);
  }

  onDestroy() {
    return $(window).off(`resize.score_slider_${this.cid}`);
  }

  onGrabberMouseDown() {
    return this.ui.grabber.draggable('option', 'containment', this.absoluteBoundaryBox());
  }

  initialize(options) {
    this.vent = options.vent;
    this.rubric = options.rubric;
    return this.listenTo(this.vent, 'range:open', () => {
      return this.updatePositionFromModel();
    });
  }

  updatePositionFromModel() {
    if (this.isDestroyed !== true) {
      const startPosition = this.translatePercentageToPosition(this.model.get('percentage'));
      return this.updateBarAndGrabberPosition(startPosition, false, false);
    }
  }

  onShow() {
    const config = {
      axis: "x"
    };
    this.ui.grabber.draggable(config);

    return setTimeout(() => {
      return this.updatePositionFromModel();
    }
    , 0);
  }

  serializeData() {
    const sd = super.serializeData();
    return sd;
  }

  onRender() {
    return this.onShow();
  }
}
