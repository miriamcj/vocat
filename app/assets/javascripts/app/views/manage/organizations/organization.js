/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


export default class ManageOrganizationView extends Marionette.ItemView {
  constructor(options) {
    super(options);

    this.template = false;

    this.ui = {
      ldapEnabled: '[data-class="ldap-enabled"]',
      ldapFields: '[data-class="ldap-fields"]'

    };

    this.triggers = {
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
