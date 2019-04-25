/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/project/dialog.hbs';

export default class ProjectDialogView extends Marionette.ItemView.extend({
  template: template
}) {
  initialize() {
    return this.model.fetch();
  }
};
