/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['marionette', 'views/group/cell'], function(Marionette, ItemView) {
  let Row;
  return Row = (function() {
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
});
