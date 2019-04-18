/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

import UserModel from 'models/user';

export default class UserCollection extends Backbone.Collection {
  constructor() {

    this.model = UserModel;

    this.activeModel = null;

    this.url = '/api/v1/users';
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
