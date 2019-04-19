/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'backbone.marionette';
import template from 'hbs!templates/layout/loading';

export default class LoadingView extends Marionette.ItemView {
  constructor() {

    this.msg = "Loading...";

    this.template = template;
  }

  serializeData() {
    return {
    msg: Marionette.getOption(this, "msg")
    };
  }

  initialize(options) {
    return this.options = options;
  }
};

