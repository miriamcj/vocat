/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import SubmissionCollection from 'collections/submission_collection';

export default SubmissionForCourseUserCollection = (function() {
  SubmissionForCourseUserCollection = class SubmissionForCourseUserCollection extends SubmissionCollection {
    static initClass() {

      this.prototype.url = '/api/v1/submissions/for_course_and_user';
    }
  };
  SubmissionForCourseUserCollection.initClass();
  return SubmissionForCourseUserCollection;
})();
