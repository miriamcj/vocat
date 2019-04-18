/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

import RubricModel from 'models/rubric';

export default RubricCollection = (function() {
  RubricCollection = class RubricCollection extends Backbone.Collection {
    static initClass() {
      this.prototype.model = RubricModel;
    }
  };
  RubricCollection.initClass();
  return RubricCollection;
})();

