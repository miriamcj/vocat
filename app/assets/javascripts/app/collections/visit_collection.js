/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

import Marionette from 'marionette';
import VisitModel from 'models/visit';

export default class VisitCollection extends Backbone.Collection {
  static initClass() {

    this.prototype.model = VisitModel;
  }

  initialize(models, options) {
    return this.options = options;
  }
};
