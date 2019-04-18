/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let PlayerAnnotations;
  const Marionette = require('marionette');
  const ItemView = require('views/assets/player/player_annotations_item');

  return PlayerAnnotations = (function() {
    PlayerAnnotations = class PlayerAnnotations extends Marionette.CollectionView {
      static initClass() {
  
        this.prototype.template = _.template('');
        this.prototype.showTimePadding = 1;
        this.prototype.hideTimePadding = .1;
  
        this.prototype.tagName = 'ul';
        this.prototype.attributes = {
          class: 'annotations-overlay'
        };
        this.prototype.childView = ItemView;
      }

      childViewOptions(model, index) {
        return {
        vent: this.vent,
        assetHasDuration: this.model.hasDuration()
        };
      }

      setupListeners() {}

      initialize(options) {
        this.collection = this.model.annotations();
        this.vent = options.vent;
        return this.setupListeners();
      }
    };
    PlayerAnnotations.initClass();
    return PlayerAnnotations;
  })();
});
