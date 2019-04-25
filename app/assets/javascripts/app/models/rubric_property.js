/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import { uniq, reject } from "lodash";

export default class RubricProperty extends Backbone.Model.extend({
  errorStrings: {},
  idAttribute: "id"
}) {
  hasErrors() {
    if (this.errors.length > 0) { return true; } else { return false; }
  }

  errorMessages() {
    const messages = new Array;
    this.errors.forEach((error, index, list) => {
      let message;
      if (this.errorStrings[error] != null) {
        message = this.errorStrings[error];
      } else {
        message = error;
      }
      return messages.push(message);
    });
    return messages;
  }

  initialize() {
    if ((this.get('id') == null)) { this.set('id', this.cid.replace('c', '')); }
    return this.errors = new Array;
  }

  addError(key) {
    this.errors.forEach(function(error, index, list) {
      if (error === key) { return list.splice(index, 1); }
    });
    return this.errors.push(key);
  }

  removeError(error_key) {
    const errors = uniq(this.errors, false);
    return this.errors = reject(errors, error => {
      return error === error_key;
    });
  }
}
