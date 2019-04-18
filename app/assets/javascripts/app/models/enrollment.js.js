/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['backbone'], function(Backbone) {
  let EnrollmentModel;
  return EnrollmentModel = (function() {
    EnrollmentModel = class EnrollmentModel extends Backbone.Model {
      static initClass() {
  
        this.prototype.urlRoot = "/api/v1/enrollments";
      }
    };
    EnrollmentModel.initClass();
    return EnrollmentModel;
  })();
});