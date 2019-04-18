/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let SubmissionCollection;
  const Marionette = require('marionette');
  const Backbone = require('backbone');
  const SubmissionModel = require('models/submission');

  return SubmissionCollection = (function() {
    SubmissionCollection = class SubmissionCollection extends Backbone.Collection {
      static initClass() {
  
        this.prototype.model = SubmissionModel;
      }

      initialize(models, options) {
        return this.options = options;
      }

      comparator(submission) {
        return submission.get('project_name');
      }
    };
    SubmissionCollection.initClass();
    return SubmissionCollection;
  })();
});