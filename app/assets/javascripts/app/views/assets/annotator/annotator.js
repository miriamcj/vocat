/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let AnnotatorView;
  const Marionette = require('marionette');
  const template = require('hbs!templates/assets/annotator/annotator');
  const ProgressBarView = require('views/assets/annotator/progress_bar');
  const AnnotationInputView = require('views/assets/annotator/annotator_input');
  const AnnotationModel = require('models/annotation');
  const ModalConfirmView = require('views/modal/modal_confirm');

  return AnnotatorView = (function() {
    AnnotatorView = class AnnotatorView extends Marionette.LayoutView {
      static initClass() {
  
        this.prototype.template = template;
        this.prototype.hideProgressBar = false;
  
        this.prototype.regions = {
          progressBar: '[data-behavior="progress-bar"]',
          annotationInput: '[data-region="annotator-input"]'
        };
  
        this.prototype.ui = {
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
    };
    AnnotatorView.initClass();
    return AnnotatorView;
  })();
});
