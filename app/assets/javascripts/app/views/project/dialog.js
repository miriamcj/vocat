/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import template from 'hbs!templates/project/dialog';

export default class ProjectDialogView extends Marionette.ItemView {
  static initClass() {

    this.prototype.template = template;
  }

  initialize() {
    return this.model.fetch();
  }
};