/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import marionette from 'marionette';
import ProjectCollection from 'collections/project_collection';
import template from 'hbs!templates/course/manage/projects/projects';
import ProjectsRowView from 'views/course/manage/projects/project_row';
import SortableTable from 'behaviors/sortable_table';

export default class Projects extends Marionette.CompositeView {
  constructor() {

    this.template = template;
    this.childView = ProjectsRowView;
    this.childViewContainer = 'tbody';

    this.behaviors = {
      sortableTable: {
        behaviorClass: SortableTable
      }
    };
  }

  initialize(options) {}
};

