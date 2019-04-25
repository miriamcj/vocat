/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import { isNaN } from "lodash";
import VocatController from 'controllers/vocat_controller';
import EnrollmentCollection from 'collections/enrollment_collection';
import EnrollmentLayout from 'views/admin/enrollment_layout';
import ProjectCollection from 'collections/project_collection';
import Projects from 'views/course/manage/projects/projects';

export default class CourseController extends VocatController.extend({
  collections: {
    project: new ProjectCollection([])
  }
}) {
  initialize() {
    return this.bootstrapCollections();
  }

  creatorEnrollment(courseId) {
    if (!isNaN(parseInt(courseId))) {
      window.Vocat.addRegions({
        creatorEnrollment: '[data-region="creator-enrollment"]'
      });
      const view = new EnrollmentLayout({
        collection: new EnrollmentCollection([], {scope: {course: courseId, role: 'creator'}})
      });
      return window.Vocat.creatorEnrollment.show(view);
    }
  }


  courseManageProjects(courseId) {
    if (!isNaN(parseInt(courseId))) {
      if ($('[data-region="projects"]').length > 0) {
        window.Vocat.addRegions({
          projects: '[data-region="projects"]'
        });
        const view = new Projects({collection: this.collections.project});
        return window.Vocat.projects.show(view);
      }
    }
  }
}
