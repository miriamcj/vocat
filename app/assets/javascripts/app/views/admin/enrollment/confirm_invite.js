/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import template from 'hbs!templates/admin/enrollment/confirm_invite';
import GlobalNotification from 'behaviors/global_notification';

export default class ConfirmInvite extends Marionette.ItemView {
  static initClass() {

    this.prototype.template = template;

    this.prototype.klass = 'confirmInvite';

    this.prototype.ui = {
      button: '[data-behavior="submit-invite-and-enroll"]'
    };

    this.prototype.triggers = {
      'click [data-behavior="cancel-invite-and-enroll"]': 'cancel',
      'click [data-behavior="submit-invite-and-enroll"]': 'submit'
    };

    this.prototype.behaviors = {
      globalNotification: {
        behaviorClass: GlobalNotification
      }
    };
  }

  onCancel() {
    return Vocat.vent.trigger('notification:empty');
  }

  onSubmit() {
    let endpoint;
    const contact_strings = new Array;
    _.each(this.contacts, contact => contact_strings.push(contact.string));
    const contact_string = contact_strings.join("\n");
    this.ui.button.addClass('loading');
    if (this.collection.searchType() === 'user') {
      endpoint = this.collection.bulkUrl();
    }
    return $.ajax(endpoint, {
      type: 'POST',
      dataType: 'json',
      data: {contacts: contact_string, invite: true},
      success: (data, textStatus, jqXHR) => {
        return this.handleSubmitSuccess(jqXHR.responseJSON);
      },
      error: (jqXHR, textStatus, error) => {
        Vocat.vent.trigger('error:add', {level: 'error', lifetime: 5000, msg: jqXHR.responseJSON.errors});
        this.ui.button.removeClass('loading');
        return this.onCancel();
      }
    });
  }

  handleSubmitSuccess(response) {
    this.ui.button.removeClass('loading');
    const successes = [];
    const failures = [];
    _.each(response, contact => {
      if (contact.success === true) {
        return successes.push(contact);
      } else {
        return failures.push(contact);
      }
    });

    this.collection.fetch();
    this.onCancel();

    Vocat.vent.trigger('error:add', {level: 'notice', lifetime: 10000, msg: _.pluck(successes, 'message')});
    return Vocat.vent.trigger('error:add', {level: 'error', lifetime: 10000, msg: _.pluck(failures, 'message')});
  }

  initialize(options) {
    this.contacts = options.contacts;
    return this.vent = options.vent;
  }

  serializeData() {
    const out = {
      contact_emails: _.pluck(this.contacts, 'email').join(', '),
      contacts_count: this.contacts.length,
      multiple_contacts: this.contacts.length > 1,
      contacts: this.contacts
    };
    return out;
  }
};
