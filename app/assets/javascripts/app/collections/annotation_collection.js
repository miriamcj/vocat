/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define([
  'backbone',
  'models/annotation'
], function(Backbone, AnnotationModel) {
  let AnnotationCollection;
  return AnnotationCollection = (function() {
    AnnotationCollection = class AnnotationCollection extends Backbone.Collection {
      static initClass() {
        this.prototype.model = AnnotationModel;
        this.prototype.assetHasDuration = false;
  
        this.prototype.url = '/api/v1/annotations';
      }

      initialize(models, options) {
        return this.assetHasDuration = Marionette.getOption(this, 'assetHasDuration');
      }

      comparator(annotation) {
        if (this.assetHasDuration) {
          return annotation.get('seconds_timecode') * -1;
        } else {
          return annotation.get('created_at_timestamp') * -1;
        }
      }

      getCurrentActive() {
        return this.find(model => model.get('active') === true);
      }

      lastActiveModelForSeconds(seconds) {
        if (this.length > 0) {
          let firstActive;
          const candidates = this.filter(annotation => annotation.get('seconds_timecode') <= seconds);
          const sortedCandidates = _.sortBy(candidates, annotation => annotation.get('seconds_timecode') * -1);
          return firstActive = _.first(sortedCandidates);
        }
      }

      deactivateAllModels(exceptForId = null) {
        return this.each(function(annotation) {
          if (exceptForId !== annotation.id) {
            return annotation.set('active', false);
          }
        });
      }

      activateModel(model) {
        this.deactivateAllModels(model.id);
        const currentState = model.get('active');
        if ((currentState === false) || (currentState == null)) {
          model.set('active', true);
          return this.trigger('model:activated');
        }
      }

      setActive(seconds) {
        const currentActive = this.getCurrentActive();
        const modelToActivate = this.lastActiveModelForSeconds(seconds);
        if (modelToActivate) {
          return this.activateModel(modelToActivate);
        } else {
          this.deactivateAllModels();
          return this.trigger('models:deactivated');
        }
      }
    };
    AnnotationCollection.initClass();
    return AnnotationCollection;
  })();
});

