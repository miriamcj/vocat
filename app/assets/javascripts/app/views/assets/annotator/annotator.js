/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import { $ } from "jquery";
import template from 'hbs!templates/assets/annotator/annotator';
import ProgressBarView from 'views/assets/annotator/progress_bar';
import AnnotationInputView from 'views/assets/annotator/annotator_input';
import AnnotationModel from 'models/annotation';
import ModalConfirmView from 'views/modal/modal_confirm';

export default class AnnotatorView extends Marionette.LayoutView {
  constructor() {

    this.template = template;
    this.hideProgressBar = false;

    this.regions = {
      progressBar: '[data-behavior="progress-bar"]',
      annotationInput: '[data-region="annotator-input"]'
    };

    this.ui = {
    };
  }

  setupListeners() {
    this.listenTo(this.vent, 'request:annotator:save', this.saveAnnotation, this);
    return this.listenTo(this.collection, 'destroy', this.handleAnnotationDestruction, this);
  }

  saveAnnotation(annotation, properties) {
    this.listenToOnce(this.vent, 'announce:status', response => {
      this.listenToOnce(this.vent, 'announce:canvas', canvas => {
        const secondsTimecode = response.playedSeconds;
        properties['canvas'] = canvas;
        properties['published'] = true;
        properties['seconds_timecode'] = secondsTimecode;
        return annotation.save(properties, {
            success: annotation => this.handleAnnotationSaveSuccess(annotation),
            error: (annotation, xhr) => this.handleAnnotationSaveError(annotation, xhr)
          }
        );
      });
      return this.vent.trigger('request:canvas', {});
    });
    return this.vent.trigger('request:status', {});
  }

  handleAnnotationSaveSuccess(annotation) {
    this.collection.add(annotation, {merge: true});
    annotation.activate();
    return this.vent.trigger('request:status', {});
  }

  handleAnnotationSaveError(annotation, xhr) {
    return Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: xhr.responseJSON.errors});
  }

  handleAnnotationDestruction(annotation) {
    if (this.annotationInput.currentView.model === annotation) {
      return this.vent.trigger('request:annotator:input:stop');
    }
  }

  initialize(options) {
    this.vent = options.vent;
    this.collection = this.model.annotations();
    window.zd = this.collection;
    return this.setupListeners();
  }

  onShow() {
    if (this.model.hasDuration()) {
      this.progressBar.show(new ProgressBarView({model: this.model, vent: this.vent, collection: this.collection}));
    } else {
      $(this.progressBar.el).hide();
    }
    this.annotatorInputView = new AnnotationInputView({
      asset: this.model,
      model: new AnnotationModel({asset_id: this.model.id}),
      vent: this.vent,
      collection: this.collection
    });
    return this.annotationInput.show(this.annotatorInputView);
  }
}
