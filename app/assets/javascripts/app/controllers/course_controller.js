/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let CourseController;
import marionette from 'marionette';
import VocatController from 'controllers/vocat_controller';
import EnrollmentCollection from 'collections/enrollment_collection';
import EnrollmentLayout from 'views/admin/enrollment_layout';
import ProjectCollection from 'collections/project_collection';
import Projects from 'views/course/manage/projects/projects';

export default CourseController = (function() {
  CourseController = class CourseController extends VocatController {
    static initClass() {

      this.prototype.collections = {
        project: new ProjectCollection([])
      };
    }

    initialize() {
      return this.bootstrapCollections();
    }

    creatorEnrollment(courseId) {
      if (!_.isNaN(parseInt(courseId))) {
        Vocat.addRegions({
          creatorEnrollment: '[data-region="creator-enrollment"]'
        });
        const view = new EnrollmentLayout({
          collection: new EnrollmentCollection([], {scope: {course: courseId, role: 'creator'}})
        });
        return Vocat.creatorEnrollment.show(view);
      }
    }


    courseManageProjects(courseId) {
      if (!_.isNaN(parseInt(courseId))) {
        if ($('[data-region="projects"]').length > 0) {
          Vocat.addRegions({
            projects: '[data-region="projects"]'
          });
          const view = new Projects({collection: this.collections.project});
          return Vocat.projects.show(view);
        }
      }
    }
  };
  CourseController.initClass();
  return CourseController;
})();
