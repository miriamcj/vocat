/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/assets/asset_collection.hbs';
import ChildView from 'views/assets/asset_collection_child';
import EmptyView from 'views/assets/asset_collection_empty';

export default class AssetCollection extends Marionette.CompositeView.extend({
  childView: ChildView,
  template: template,
  childViewContainer: '[data-behavior="collection-container"]',

  ui: {
    collectionContainer: '[data-behavior="collection-container"]'
  },

  triggers: {
    'click [data-behavior="do-render"]': 'forceRender'
  },

  emptyView: EmptyView
}) {
  childViewOptions() {
    return {
    vent: this.vent,
    abilities: this.abilities
    };
  }

  emptyViewOptions() {
    return {
    model: this.project,
    abilities: this.abilities,
    vent: this.vent
    };
  }

  onForceRender() {
    return this.render();
  }

  setupListeners() {
    return this.listenTo(this.collection, 'change:listing_order', function(e) {
      return this.render();
    });
  }

  initialize(options) {
    this.vent = Marionette.getOption(this, 'vent');
    this.abilities = options.abilities;
    this.project = options.project;
    return this.setupListeners();
  }
};
