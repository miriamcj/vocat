/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'backbone.marionette';
import template from 'hbs!templates/notification/notification_exception';
import GlobalNotification from 'behaviors/global_notification';

export default class NotificationException extends Marionette.ItemView {
  constructor() {

    this.template = template;

    this.behaviors = {
      globalNotification: {
        behaviorClass: GlobalNotification
      }
    };
  }

  serializeData() {
    return {
    msg: this.msg
    };
  }

  initialize(options) {
    return this.msg = options.msg;
  }
};
