/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let SubmissionForProjectCollection;
import SubmissionCollection from 'collections/submission_collection';

export default SubmissionForProjectCollection = (function() {
  SubmissionForProjectCollection = class SubmissionForProjectCollection extends SubmissionCollection {
    static initClass() {

      this.prototype.url = '/api/v1/submissions/for_project';
    }
  };
  SubmissionForProjectCollection.initClass();
  return SubmissionForProjectCollection;
})();
