/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import Backbone from 'backbone';
import SubmissionModel from 'models/submission';

export default class SubmissionCollection extends Backbone.Collection {
  static initClass() {

    this.prototype.model = SubmissionModel;
  }

  initialize(models, options) {
    return this.options = options;
  }

  comparator(submission) {
    return submission.get('project_name');
  }
};