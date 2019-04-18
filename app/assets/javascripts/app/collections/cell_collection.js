/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

import CellModel from 'models/cell';
let CellCollection;

export default CellCollection = (function() {
  CellCollection = class CellCollection extends Backbone.Collection {
    static initClass() {
      this.prototype.model = CellModel;
    }

    comparator(range) {
      return range.get('low');
    }
  };
  CellCollection.initClass();
  return CellCollection;
})();