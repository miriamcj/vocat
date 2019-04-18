/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import ItemView from 'views/group/cell';
let Row;

export default Row = (function() {
  Row = class Row extends Marionette.CollectionView {
    static initClass() {

      this.prototype.tagName = 'tr';
      this.prototype.className = 'matrix--row';

      this.prototype.childView = ItemView;
    }

    childViewOptions() {
      return {
      vent: this.vent,
      creator: this.model
      };
    }

    initialize(options) {
      return this.vent = options.vent;
    }

    onAddChild() {
      return this.vent.trigger('recalculate');
    }

    onRemoveChild() {
      return this.vent.trigger('recalculate');
    }
  };
  Row.initClass();
  return Row;
})();
