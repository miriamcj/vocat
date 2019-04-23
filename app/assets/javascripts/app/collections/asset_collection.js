/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import AssetModel from 'models/asset';

export default class AssetCollection extends Backbone.Collection {
  constructor() {

    this.submissionId = null;
    this.model = AssetModel;

    this.url = '/api/v1/assets';
  }

  comparator(asset) {
    const c = asset.get('listing_order');
    return parseInt(c);
  }

  initialize(models, options) {
    if (options && options.hasOwnProperty('submissionId')) {
      this.submissionId = options.submissionId;
    }
    return this.setupListeners();
  }

  highIndex() {
    return this.length - 1;
  }

  lowIndex() {
    return 0;
  }

  getPreviousModel(model) {
    const index = this.indexOf(model);
    if ((index - 1) >= this.lowIndex()) {
      return this.at(index - 1);
    } else {
      return null;
    }
  }

  getNextModel(model) {
    const index = this.indexOf(model);
    if ((index + 1) <= this.highIndex()) {
      return this.at(index + 1);
    } else {
      return null;
    }
  }

  getPositionBetween(low, high) {
    return Math.round(low + ((high - low) / 2));
  }

  moveUp(model) {
    const previousModel = this.getPreviousModel(model);
    if (previousModel) {
      let betweenLow;
      const betweenHigh = previousModel.get('listing_order');
      const previousPreviousModel = this.getPreviousModel(previousModel);
      if (previousPreviousModel) {
        betweenLow = previousPreviousModel.get('listing_order');
      } else {
        betweenLow = -8388607;
      }
      const newPosition = this.getPositionBetween(betweenLow, betweenHigh);
      model.set('listing_order', newPosition);
      return this.sort();
    }
    else {}
  }
      // Can't move past itself. Do nothing.

  moveDown(model) {
    const nextModel = this.getNextModel(model);
    if (nextModel) {
      let betweenHigh;
      const betweenLow = nextModel.get('listing_order');
      const nextNextModel = this.getNextModel(nextModel);
      if (nextNextModel) {
        betweenHigh = nextNextModel.get('listing_order');
      } else {
        betweenHigh = 8388607;
      }
      const newPosition = this.getPositionBetween(betweenLow, betweenHigh);
      model.set('listing_order', newPosition);
      return this.sort();
    }
    else {}
  }
      // Can't move past itself. Do nothing.

  setupListeners() {
    this.listenTo(this, 'add', model => {
      return model.set('submission_id', this.submissionId);
    });
    return this.listenTo(this, 'sort', function(e) {
      return this.each((model, index) => model.set('listing_order_position', index));
    });
  }
};
