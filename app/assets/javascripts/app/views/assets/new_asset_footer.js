/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/assets/new_asset_footer.hbs';

export default class NewAssetFooter extends Marionette.ItemView.extend({
  template: template,

  ui: {
    stopManagingLink: '[data-behavior="stop-manage-link"]'
  }
}) {
  preventManageClose() {
    return this.ui.stopManagingLink.css({display: 'none'});
  }

  allowManageClose() {
    return this.ui.stopManagingLink.css({display: 'inline-block'});
  }

  initialize(options) {
    return this.vent = Marionette.getOption(this, 'vent');
  }
};