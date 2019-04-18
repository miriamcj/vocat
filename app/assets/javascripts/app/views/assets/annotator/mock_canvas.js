/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

export default class MockCanvasView extends Marionette.ItemView {
  static initClass() {

    this.prototype.template = false;
  }

  initialize(options) {
    this.vent = options.vent;
    this.collection = this.model.annotations();
    return this.setupListeners();
  }

  setupListeners() {
    return this.listenTo(this.vent, 'request:canvas', this.announceCanvas, this);
  }

  announceCanvas() {
    const json = null;
    const svg = null;
    return this.vent.trigger('announce:canvas', JSON.stringify({json, svg}));
  }
};
