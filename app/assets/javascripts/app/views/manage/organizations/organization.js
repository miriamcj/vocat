/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import marionette from 'marionette';

export default class ManageOrganizationView extends Marionette.ItemView {
  static initClass() {

    this.prototype.template = false;

    this.prototype.ui = {
      ldapEnabled: '[data-class="ldap-enabled"]',
      ldapFields: '[data-class="ldap-fields"]'

    };

    this.prototype.triggers = {
      'change @ui.ldapEnabled': 'change:ldap:enabled'
    };
  }

  onChangeLdapEnabled() {
    const val = this.ui.ldapEnabled.val();
    if (val === 'true') {
      console.log('showing');
      return this.ui.ldapFields.show();
    } else {
      console.log('hiding');
      return this.ui.ldapFields.hide();
    }
  }


  initialize() {
    return this.render();
  }

  onRender(options) {
    return this.onChangeLdapEnabled();
  }
};

