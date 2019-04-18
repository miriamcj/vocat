/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import template from 'hbs!templates/project/detail/project_submission_row';
import Backbone from 'backbone';

export default class ProjectSubmissionRowView extends Marionette.ItemView {
  static initClass() {

    this.prototype.tagName = "tr";
    this.prototype.template = template;
    this.prototype.attributes = {
      'data-region': 'submission-row'
    };

    this.prototype.triggers = {
      'click': 'rowClick'
    };
  }

  onRowClick() {
    const typeSegment = `${this.model.get('creator_type').toLowerCase()}s`;
    const url = `courses/${this.model.get('course_id')}/${typeSegment}/evaluations/creator/${this.model.get('creator_id')}/project/${this.model.get('project_id')}`;
    return Vocat.router.navigate(url, true);
  }

  initialize(options) {
    this.options = options || {};
    return this.vent = options.vent;
  }
};
