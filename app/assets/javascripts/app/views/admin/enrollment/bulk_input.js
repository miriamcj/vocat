/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import { pluck } from "lodash";
const jqueryUI = require("jquery-ui");
const ajaxChosen = require("chosen");
import ConfirmInvite from 'views/admin/enrollment/confirm_invite';
import template from 'templates/admin/enrollment/bulk_input.hbs';

export default class EnrollmentBulkInput extends Marionette.LayoutView {
  constructor(options) {
    super(options);

    this.ui = {
      showSingle: '[data-behavior="show-single"]',
      bulkInput: '[data-behavior="bulk-input"]',
      submit: '[data-behavior="submit"]'
    };

    this.triggers = {
      'click [data-behavior="show-single"]': 'showSingle',
      'click [data-behavior="submit"]': 'submit'
    };

    this.regions = {
      confirmInvite: '[data-region="confirm-invite"]'
    };

    this.template = template;
  }


  initialize(options) {
    return this.vent = options.vent;
  }

  onSubmit() {
    let endpoint;
    this.ui.submit.addClass('loading');
    const contacts = this.ui.bulkInput.val();
    if (this.collection.searchType() === 'user') {
      endpoint = this.collection.bulkUrl();
    }
    return $.ajax(endpoint, {
      type: 'POST',
      dataType: 'json',
      data: {contacts, invite: false},
      success: (data, textStatus, jqXHR) => {
        return this.handleSubmitSuccess(jqXHR.responseJSON);
      },
      error: (jqXHR, textStatus, error) => {
        this.ui.submit.removeClass('loading');
        return Vocat.vent.trigger('error:add', {level: 'error', lifetime: 5000, msg: jqXHR.responseJSON.errors});
      }
    });
  }

  showInviteMustConfirm(contacts) {
    return Vocat.vent.trigger('notification:show',
      new ConfirmInvite({collection: this.collection, contacts, vent: this.vent}));
  }

  handleSubmitSuccess(response) {
    this.ui.submit.removeClass('loading');
    const confirm = [];
    const failures = [];
    const successes = [];
    const strings = [];
    response.forEach(contact => {
      if (contact.success === true) {
        return successes.push(contact);
      } else if ((contact.success === false) && (contact.reason === 'must_confirm')) {
        strings.push(contact.string);
        return confirm.push(contact);
      } else {
        strings.push(contact.string);
        return failures.push(contact);
      }
    });
    Vocat.vent.trigger('error:add', {level: 'notice', lifetime: 10000, msg: pluck(successes, 'message')});
    Vocat.vent.trigger('error:add', {level: 'error', lifetime: 10000, msg: pluck(failures, 'message')});

    const inputValue = strings.join("\n");
    this.ui.bulkInput.val(inputValue);

    if (confirm.length > 0) {
      this.showInviteMustConfirm(confirm);
    }

    return this.collection.fetch();
  }
}
