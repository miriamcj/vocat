/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/project/detail/project_submission_row.hbs';


export default class ProjectSubmissionRowView extends Marionette.ItemView {
  constructor(options) {
    super(options);

    this.tagName = "tr";
    this.template = template;
    this.attributes = {
      'data-region': 'submission-row'
    };

    this.triggers = {
      'click': 'rowClick'
    };
  }

  onRowClick() {
    const typeSegment = `${this.model.get('creator_type').toLowerCase()}s`;
    const url = `courses/${this.model.get('course_id')}/${typeSegment}/evaluations/creator/${this.model.get('creator_id')}/project/${this.model.get('project_id')}`;
    return window.Vocat.router.navigate(url, true);
  }

  initialize(options) {
    this.options = options || {};
    return this.vent = options.vent;
  }
};
