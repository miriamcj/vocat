/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import ItemView from 'views/group/cell';

export default class Row extends Marionette.CollectionView.extend({
  tagName: 'tr',
  className: 'matrix--row',
  childView: ItemView
}) {
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
