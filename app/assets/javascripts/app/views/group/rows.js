/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import ItemView from 'views/group/row_item';
let RowsView;

export default RowsView = (function() {
  RowsView = class RowsView extends Marionette.CollectionView {
    static initClass() {

      this.prototype.childView = ItemView;
    }

    childViewOptions() {
      return {
      vent: this.vent,
      collection: this.collections.group
      };
    }

    initialize(options) {
      this.collections = options.collections;
      return this.vent = options.vent;
    }
  };
  RowsView.initClass();
  return RowsView;
})();
