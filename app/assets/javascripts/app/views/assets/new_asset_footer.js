/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let NewAssetFooter;
const Marionette = require('marionette');
const template = require('hbs!templates/assets/new_asset_footer');

export default NewAssetFooter = (function() {
  NewAssetFooter = class NewAssetFooter extends Marionette.ItemView {
    static initClass() {

      this.prototype.template = template;

      this.prototype.ui = {
        stopManagingLink: '[data-behavior="stop-manage-link"]'
      };
    }

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
  NewAssetFooter.initClass();
  return NewAssetFooter;
})();