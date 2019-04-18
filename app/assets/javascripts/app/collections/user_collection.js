/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

import UserModel from 'models/user';
let UserCollection;

export default UserCollection = (function() {
  UserCollection = class UserCollection extends Backbone.Collection {
    static initClass() {

      this.prototype.model = UserModel;

      this.prototype.activeModel = null;

      this.prototype.url = '/api/v1/users';
    }

    getSearchTerm() {
      return 'email';
    }

    getActive() {
      return this.activeModel;
    }

    setActive(id) {
      const current = this.getActive();
      if (id != null) {
        const model = this.get(id);
        if (model != null) {
          this.activeModel = model;
        } else {
          this.activeModel = null;
        }
      } else {
        this.activeModel = null;
      }
      if (this.activeModel !== current) {
        return this.trigger('change:active', this.activeModel);
      }
    }
  };
  UserCollection.initClass();
  return UserCollection;
})();
