/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import ProjectSubmissionRowView from 'views/project/detail/project_submission_row';
import template from 'templates/project/detail/project_submission_list.hbs';

export default class ProjectSubmissionListView extends Marionette.CompositeView {
  constructor(options) {
    super(options);

    this.tagName = "table";
    this.className = "table project-details-table";
    this.template = template;
    this.childView = ProjectSubmissionRowView;
    this.childViewContainer = "tbody";
  }

  childViewOptions() { return {
    vent: this.vent
  }; }

  initialize(options) {
    this.options = options || {};
    this.vent = options.vent;
    this.projectId = Marionette.getOption(this, 'projectId');
    return this.projectType = Marionette.getOption(this, 'projectType');
  }
};
