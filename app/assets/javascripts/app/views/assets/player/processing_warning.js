/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'backbone.marionette';
import template from 'hbs!templates/assets/player/processing_warning';

export default class ProcessingWarningView extends Marionette.ItemView {
  constructor() {

    this.template = template;
  }
};

