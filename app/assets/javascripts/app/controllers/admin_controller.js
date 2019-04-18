/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import VocatController from 'controllers/vocat_controller';
import EnrollmentCollection from 'collections/enrollment_collection';
import EnrollmentLayout from 'views/admin/enrollment_layout';

export default class AdminController extends VocatController {
  static initClass() {

    this.prototype.collections = {
    };
  }

  evaluatorEnrollment(courseId) {
    if (!_.isNaN(parseInt(courseId))) {
      Vocat.addRegions({
        evaluatorEnrollment: '[data-region="evaluator-enrollment"]'
      });
      const view = new EnrollmentLayout({
        collection: new EnrollmentCollection([], {scope: {course: courseId, role: 'evaluator'}})
      });
      return Vocat.evaluatorEnrollment.show(view);
    }
  }

  assistantEnrollment(courseId) {
    if (!_.isNaN(parseInt(courseId))) {
      Vocat.addRegions({
        assistantEnrollment: '[data-region="assistant-enrollment"]'
      });
      const view = new EnrollmentLayout({
        collection: new EnrollmentCollection([], {scope: {course: courseId, role: 'assistant'}})
      });
      return Vocat.assistantEnrollment.show(view);
    }
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

  courseEnrollment(userId) {
    if (!_.isNaN(parseInt(userId))) {
      Vocat.addRegions({
        creatorEnrollment: '[data-region="creator-enrollment"]'
      });
      const view = new EnrollmentLayout({collection: new EnrollmentCollection([], {scope: {user: userId}})});
      return Vocat.creatorEnrollment.show(view);
    }
  }
};
