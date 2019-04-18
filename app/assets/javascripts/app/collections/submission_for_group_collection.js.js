/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let SubmissionForGroupCollection;
  const SubmissionCollection = require('collections/submission_collection');

  return SubmissionForGroupCollection = (function() {
    SubmissionForGroupCollection = class SubmissionForGroupCollection extends SubmissionCollection {
      static initClass() {
  
        this.prototype.url = '/api/v1/submissions/for_group';
      }
    };
    SubmissionForGroupCollection.initClass();
    return SubmissionForGroupCollection;
  })();
});
