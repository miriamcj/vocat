/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import ItemView from 'views/group/row_item';

export default class RowsView extends Marionette.CollectionView {
  constructor() {

    this.childView = ItemView;
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
