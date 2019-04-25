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

export default class AdminController extends VocatController.extend({
  collections: {
  }
}) {
  evaluatorEnrollment(courseId) {
    if (!isNaN(parseInt(courseId))) {
      window.Vocat.addRegions({
        evaluatorEnrollment: '[data-region="evaluator-enrollment"]'
      });
      const view = new EnrollmentLayout({
        collection: new EnrollmentCollection([], {scope: {course: courseId, role: 'evaluator'}})
      });
      return window.Vocat.evaluatorEnrollment.show(view);
    }
  }

  assistantEnrollment(courseId) {
    if (!isNaN(parseInt(courseId))) {
      window.Vocat.addRegions({
        assistantEnrollment: '[data-region="assistant-enrollment"]'
      });
      const view = new EnrollmentLayout({
        collection: new EnrollmentCollection([], {scope: {course: courseId, role: 'assistant'}})
      });
      return window.Vocat.assistantEnrollment.show(view);
    }
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

  courseEnrollment(userId) {
    if (!isNaN(parseInt(userId))) {
      window.Vocat.addRegions({
        creatorEnrollment: '[data-region="creator-enrollment"]'
      });
      const view = new EnrollmentLayout({collection: new EnrollmentCollection([], {scope: {user: userId}})});
      return window.Vocat.creatorEnrollment.show(view);
    }
  }
}
