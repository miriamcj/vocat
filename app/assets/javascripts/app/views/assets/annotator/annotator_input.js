/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/assets/annotator/annotator_input.hbs';
import AnnotationModel from 'models/annotation';

export default class AnnotatorInputView extends Marionette.ItemView {
  constructor(options) {
    super(options);

    this.template = template;
    this.canvasIsDirty = false;
    this.editLock = false;
    this.inputPointer = null;
    this.ignoreTimeUpdates = false;

    this.ui = {
      annotationInput: '[data-behavior="annotation-input"]',
      canvasDrawButton: '[data-behavior="annotation-canvas-draw"]',
      canvasEraseButton: '[data-behavior="annotation-canvas-erase"]',
      canvasOvalButton: '[data-behavior="annotation-canvas-oval"]',
      canvasSelectButton: '[data-behavior="annotation-canvas-select"]',
      annotationCreateButton: '[data-behavior="annotation-create"]',
      annotationCreateCancelButton: '[data-behavior="annotation-create-cancel"]',
      annotationUpdateButton: '[data-behavior="annotation-update"]',
      annotationEditCancelButton: '[data-behavior="annotation-edit-cancel"]',
      annotationDeleteButton: '[data-behavior="annotation-delete"]',
      annotationButtonsLeft: '[data-behavior="annotation-buttons-left"]',
      message: '[data-behavior="message"]'
    };

    this.triggers = {
      'click @ui.annotationCreateButton': 'saveAnnotation',
      'click @ui.annotationCreateCancelButton': 'cancelEdit',
      'click @ui.annotationUpdateButton': 'saveAnnotation',
      'click @ui.annotationEditCancelButton': 'cancelEdit',
      'click @ui.canvasDrawButton': 'setCanvasModeDraw',
      'click @ui.canvasEraseButton': 'setCanvasModeErase',
      'click @ui.canvasOvalButton': 'setCanvasModeOval',
      'click @ui.canvasSelectButton': 'setCanvasModeSelect',
      'click @ui.annotationInput': 'annotationInputClick'
    };

    this.events =
      {'keypress [data-behavior="annotation-input"]': 'onUserTyping'};
  }

  setupListeners() {
    this.listenTo(this, 'lock:attempted', this.handleLockAttempted, this);
    this.listenTo(this.vent, 'announce:canvas:tool', this.updateToolStates, this);
    this.listenTo(this.vent, 'announce:canvas:dirty', this.handleCanvasDirty, this);
    this.listenTo(this.vent, 'announce:canvas:clean', this.handleCanvasClean, this);
    this.listenTo(this.vent, 'request:annotator:input:edit', this.startAnnotationEdit, this);
    this.listenTo(this.vent, 'request:annotator:input:stop', this.stopAnnotationInput, this);
    this.listenTo(this.vent, 'request:message:show', this.handleMessageShow, this);
    return this.listenTo(this.vent, 'request:message:hide', this.handleMessageHide, this);
  }

  handleMessageShow(data) {
    const { msg } = data;
    this.ui.message.html(msg);
    return this.ui.message.addClass('open');
  }

  handleMessageHide(data) {
    this.ui.message.html('&nbsp;');
    return this.ui.message.removeClass('open');
  }

  initialize(options) {
    this.vent = options.vent;
    this.asset = options.asset;
    this.collection = this.asset.annotations();
    return this.setupListeners();
  }

  startAnnotationInput(force) {
    if (force == null) { force = false; }
    if ((this.inputPointer === null) || (force === true)) {
      this.listenToOnce(this.vent, 'announce:status', response => {
        let newMessage;
        this.inputPointer = response.playedSeconds;
        this.updateButtonVisibility();
        this.onSetCanvasModeSelect();
        if (this.asset.hasDuration()) {
          newMessage = `Select post to add this annotation at ${this.secondsToString(this.inputPointer)}.`;
        } else {
          newMessage = "Press post to save a new annotation.";
        }
        if (this.model.isNew()) { this.vent.trigger('request:message:show', {msg: newMessage}); }
        if (!this.model.isNew()) { this.vent.trigger('request:message:show',
          {msg: "Edit the annotation and press update to save."}); }
        this.vent.trigger('request:annotation:canvas:load', this.model);
        return this.vent.trigger('announce:annotator:input:start', {});
      });
      return this.vent.trigger('request:status', {});
    }
  }

  startAnnotationEdit(annotation) {
    this.editLock = true;
    const force = annotation !== this.model;
    return this.vent.trigger('request:time:update', {
      silent: true, seconds: annotation.get('seconds_timecode'), callback: () => {
        this.editLock = false;
        this.model = annotation;
        this.model.activate();
        this.render();
        return this.startAnnotationInput(force);
      }
      , callbackScope: this
    });
  }

  secondsToString(seconds) {
    let minutes = Math.floor(seconds / 60);
    seconds = (seconds - (minutes * 60)).toFixed(2);
    const minuteZeroes = (2 - minutes.toString().length) + 1;
    minutes = Array(+((minuteZeroes > 0) && minuteZeroes)).join("0") + minutes;
    const secondZeroes = (5 - seconds.toString().length) + 1;
    seconds = Array(+((secondZeroes > 0) && secondZeroes)).join("0") + seconds;
    return `${minutes}:${seconds}`;
  }

  stopAnnotationInput(forceModelReset) {
    if (forceModelReset == null) { forceModelReset = false; }
    if ((this.inputPointer !== null) & !this.editLock) {
      this.inputPointer = null;
      //        @vent.trigger('request:unlock', {view: @})
      this.vent.trigger('announce:annotator:input:stop', {});
      this.vent.trigger('request:annotation:canvas:disable');
      this.vent.trigger('request:resume');
      this.vent.trigger('request:status', {});
      this.vent.trigger('request:message:hide');
      this.updateButtonVisibility();
      if (!this.model.isNew() || forceModelReset) {
        this.model = new AnnotationModel({asset_id: this.asset.id});
        return this.render();
      }
    }
  }

  updateButtonVisibility() {
    if (this.inputPointer !== null) {
      this.ui.annotationButtonsLeft.show();
      this.ui.annotationCreateButton.show().removeClass('hidden');
      this.ui.annotationCreateCancelButton.show().removeClass('hidden');
      if (this.asset.allowsVisibleAnnotation()) {
        this.ui.canvasSelectButton.show().removeClass('hidden');
        return this.ui.canvasEraseButton.show().removeClass('hidden');
      }
    } else {
      this.ui.annotationButtonsLeft.hide();
      this.ui.annotationCreateButton.hide().addClass('hidden');
      this.ui.annotationCreateCancelButton.hide().addClass('hidden');

      if (!this.asset.allowsVisibleAnnotation()) {
        this.ui.canvasSelectButton.hide().addClass('hidden');
        this.ui.canvasEraseButton.hide().addClass('hidden');
        this.ui.canvasDrawButton.hide().addClass('hidden');
        return this.ui.canvasOvalButton.hide().addClass('hidden');
      }
    }
  }

  onUserTyping(event) {
    this.startAnnotationInput();
    if ((event.which === 13) && (event.shiftKey !== true)) {
      if (this.ui.annotationInput.val().length > 0) {
        this.onSaveAnnotation();
      }
      return event.preventDefault();
    }
  }

  onAnnotationInputClick() {
    return this.vent.trigger('announce:annotator:input:start');
  }

  setCanvasMode(mode) {
    this.startAnnotationInput();
    return this.vent.trigger('request:annotation:canvas:setmode', mode);
  }

  onSetCanvasModeSelect() {
    return this.setCanvasMode('select');
  }

  onSetCanvasModeDraw() {
    return this.setCanvasMode('draw');
  }

  onSetCanvasModeErase() {
    return this.setCanvasMode('erase');
  }

  onSetCanvasModeOval() {
    return this.setCanvasMode('oval');
  }

  onSaveAnnotation() {
    const body = this.ui.annotationInput.val();
    this.vent.trigger('request:annotator:save', this.model, {body});
    const forceModelReset = true;
    return this.stopAnnotationInput(forceModelReset);
  }

  onCancelEdit() {
    const forceModelReset = true;
    return this.stopAnnotationInput(forceModelReset);
  }

  handleLockAttempted() {
    return Vocat.vent.trigger('error:add', {
      level: 'info',
      clear: true,
      msg: 'Playback is locked because you are currently editing an annotation. To unlock playback, press the cancel button.'
    });
  }

  takeFocus() {
    return this.ui.annotationInput.focus();
  }

  handleCanvasDirty() {
    return this.canvasIsDirty = true;
  }

  handleCanvasClean() {
    return this.canvasIsDirty = false;
  }

  updateToolStates(activeTool) {
    this.ui.canvasDrawButton.removeClass('active');
    this.ui.canvasEraseButton.removeClass('active');
    this.ui.canvasOvalButton.removeClass('active');
    this.ui.canvasSelectButton.removeClass('active');
    if (activeTool === 'draw') {
      this.ui.canvasDrawButton.addClass('active');
    }
    if (activeTool === 'oval') {
      this.ui.canvasOvalButton.addClass('active');
    }
    if (activeTool === 'erase') {
      this.ui.canvasEraseButton.addClass('active');
    }
    if (activeTool === 'select') {
      return this.ui.canvasSelectButton.addClass('active');
    }
  }

  hideVisualAnnotationUi() {
    this.ui.canvasEraseButton.hide().addClass('hidden');
    this.ui.canvasDrawButton.hide().addClass('hidden');
    return this.ui.canvasOvalButton.hide().addClass('hidden');
  }

  isDirty() {
    return (this.ui.annotationInput.val().length > 0) || (this.canvasIsDirty === true);
  }

  onRender() {
    return this.updateButtonVisibility();
  }

  onShow() {
    this.updateButtonVisibility();
    if (!this.asset.allowsVisibleAnnotation()) {
      return this.hideVisualAnnotationUi();
    }
  }
};
