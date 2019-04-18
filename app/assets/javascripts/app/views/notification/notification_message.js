/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import template from 'hbs!templates/notification/notification_message';

export default class NotificationMessage extends Marionette.ItemView {
  constructor() {

    this.template = template;
    this.lifetime = 10000;
    this.isFlash = true;

    this.triggers = {
      'click [data-behavior="close-message"]': 'closeMessage'
    };
  }

  onCloseMessage() {
    return this.trigger('view:expired');
  }

  className() {
    return `alert alert-${this.model.get('level')}`;
  }

  initialize(options) {
    const lifetime = parseInt(this.model.get('lifetime'));
    if (lifetime > 0) { return this.lifetime = lifetime; }
  }

  onShow() {
    return setTimeout(() => {
      return this.trigger('view:expired');
    }
    , this.lifetime
    );
  }
};

