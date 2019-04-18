/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

import FieldModel from 'models/field';
let FieldCollection;

export default FieldCollection = (function() {
  FieldCollection = class FieldCollection extends Backbone.Collection {
    static initClass() {
      this.prototype.model = FieldModel;
    }
  };
  FieldCollection.initClass();
  return FieldCollection;
})();

