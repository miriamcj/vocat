/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */



import EvaluationModel from 'models/evaluation';

export default class EvaluationCollection extends Backbone.Collection {
  constructor() {

    this.model = EvaluationModel;
  }

  initialize(models, options) {
    this.options = options;
    return this.courseId = Marionette.getOption(this, 'courseId');
  }

  url() {
    return `/api/v1/courses/${this.courseId}/evaluations`;
  }
};