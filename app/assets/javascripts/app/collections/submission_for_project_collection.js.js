/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let SubmissionForProjectCollection;
  const SubmissionCollection = require('collections/submission_collection');

  return SubmissionForProjectCollection = (function() {
    SubmissionForProjectCollection = class SubmissionForProjectCollection extends SubmissionCollection {
      static initClass() {
  
        this.prototype.url = '/api/v1/submissions/for_project';
      }
    };
    SubmissionForProjectCollection.initClass();
    return SubmissionForProjectCollection;
  })();
});
