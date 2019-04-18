/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let Projects;
  const marionette = require('marionette');
  const ProjectCollection = require('collections/project_collection');
  const template = require('hbs!templates/course/manage/projects/projects');
  const ProjectsRowView = require('views/course/manage/projects/project_row');
  const SortableTable = require('behaviors/sortable_table');

  return Projects = (function() {
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
});

