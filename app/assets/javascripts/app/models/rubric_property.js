/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

let RubricProperty;

export default RubricProperty = (function() {
  RubricProperty = class RubricProperty extends Backbone.Model {
    static initClass() {

      this.prototype.errorStrings = {};
      this.prototype.idAttribute = "id";
    }

    hasErrors() {
      if (this.errors.length > 0) { return true; } else { return false; }
    }

    errorMessages() {
      const messages = new Array;
      _.each(this.errors, (error, index, list) => {
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
      _.each(this.errors, function(error, index, list) {
        if (error === key) { return list.splice(index, 1); }
      });
      return this.errors.push(key);
    }

    removeError(error_key) {
      const errors = _.uniq(this.errors, false);
      return this.errors = _.reject(errors, error => {
        return error === error_key;
      });
    }
  };
  RubricProperty.initClass();
  return RubricProperty;
})();
