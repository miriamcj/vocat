/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let ProjectSubmissionListView;
  const Marionette = require('marionette');
  const ProjectSubmissionRowView = require('views/project/detail/project_submission_row');
  const template = require('hbs!templates/project/detail/project_submission_list');

  return ProjectSubmissionListView = (function() {
    ProjectSubmissionListView = class ProjectSubmissionListView extends Marionette.CompositeView {
      static initClass() {
  
        this.prototype.tagName = "table";
        this.prototype.className = "table project-details-table";
        this.prototype.template = template;
        this.prototype.childView = ProjectSubmissionRowView;
        this.prototype.childViewContainer = "tbody";
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
    ProjectSubmissionListView.initClass();
    return ProjectSubmissionListView;
  })();
});