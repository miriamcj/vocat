/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let Projects;
import marionette from 'marionette';
import ProjectCollection from 'collections/project_collection';
import template from 'hbs!templates/course/manage/projects/projects';
import ProjectsRowView from 'views/course/manage/projects/project_row';
import SortableTable from 'behaviors/sortable_table';

export default Projects = (function() {
  Projects = class Projects extends Marionette.CompositeView {
    static initClass() {

      this.prototype.template = template;
      this.prototype.childView = ProjectsRowView;
      this.prototype.childViewContainer = 'tbody';

      this.prototype.behaviors = {
        sortableTable: {
          behaviorClass: SortableTable
        }
      };
    }

    initialize(options) {}
  };
  Projects.initClass();
  return Projects;
})();

