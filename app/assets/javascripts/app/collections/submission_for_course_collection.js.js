/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let SubmissionForCourseCollection;
  const SubmissionCollection = require('collections/submission_collection');

  return SubmissionForCourseCollection = (function() {
    SubmissionForCourseCollection = class SubmissionForCourseCollection extends SubmissionCollection {
      static initClass() {
  
        this.prototype.url = '/api/v1/submissions/for_course';
      }
    };
    SubmissionForCourseCollection.initClass();
    return SubmissionForCourseCollection;
  })();
});
