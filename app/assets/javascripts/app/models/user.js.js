/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['backbone'], function(Backbone) {
  let UserModel;
  return UserModel = (function() {
    UserModel = class UserModel extends Backbone.Model {
      static initClass() {
  
        this.prototype.creatorType = 'User';
      }
    };
    UserModel.initClass();
    return UserModel;
  })();
});