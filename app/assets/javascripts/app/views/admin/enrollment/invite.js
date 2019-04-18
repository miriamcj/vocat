/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import { pluck } from "lodash";
import template from 'hbs!templates/admin/enrollment/invite';

export default class Invite extends Marionette.ItemView {
  constructor() {

    this.template = template;

    this.ui = {
      button: '[data-behavior="submit-invite-and-enroll"]',
      input: '[data-behavior="contact"]'
    };

    this.triggers = {
      'click [data-behavior="cancel-invite-and-enroll"]': 'cancel',
      'click [data-behavior="submit-invite-and-enroll"]': 'submit'
    };
  }

  onCancel() {
    return this.ui.input.val('');
  }

  onSubmit() {
    let endpoint;
    const contact_string = this.ui.input.val();
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
        if (jqXHR.hasOwnProperty('responseJSON') && jqXHR.responseJSON.hasOwnProperty('errors')) {
          error = jqXHR.responseJSON.errors;
        } else {
          error = 'The server failed to process the invitation.';
        }
        Vocat.vent.trigger('error:add', {level: 'error', lifetime: 5000, msg: error});
        this.ui.button.removeClass('loading');
        return this.onCancel();
      }
    });
  }

  handleSubmitSuccess(response) {
    this.ui.button.removeClass('loading');
    const successes = [];
    const failures = [];
    response.forEach(contact => {
      if (contact.success === true) {
        return successes.push(contact);
      } else {
        return failures.push(contact);
      }
    });
    Vocat.vent.trigger('error:add', {level: 'notice', lifetime: 10000, msg: pluck(successes, 'message')});
    Vocat.vent.trigger('error:add', {level: 'error', lifetime: 10000, msg: pluck(failures, 'message')});
    this.collection.fetch();
    return this.onCancel();
  }

  initialize(options) {
    return this.vent = options.vent;
  }

  serializeData() {
    const out = {
      showInput: this.showInput,
      contacts: this.contacts
    };
    return out;
  }
}
