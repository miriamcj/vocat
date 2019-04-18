/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

import FlashMessageModel from 'models/flash_message';

export default class FlashMessageCollection extends Backbone.Collection {
  static initClass() {

    this.prototype.model = FlashMessageModel;
  }

  initialize() {}
};
