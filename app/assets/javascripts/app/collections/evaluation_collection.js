/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['backbone', 'marionette', 'models/evaluation'], function(Backbone, Marionette, EvaluationModel) {
  let EvaluationCollection;
  return EvaluationCollection = (function() {
    EvaluationCollection = class EvaluationCollection extends Backbone.Collection {
      static initClass() {
  
        this.prototype.model = EvaluationModel;
      }

      initialize(models, options) {
        this.options = options;
        return this.courseId = Marionette.getOption(this, 'courseId');
      }

      url() {
        return `/api/v1/courses/${this.courseId}/evaluations`;
      }
    };
    EvaluationCollection.initClass();
    return EvaluationCollection;
  })();
});