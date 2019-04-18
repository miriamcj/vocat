/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['backbone'], function(Backbone) {
  let VisitModel;
  return (VisitModel = class VisitModel extends Backbone.Model {

    url() {
      return "/api/v1/visits";
    }
  });
});
      