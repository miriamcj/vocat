/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let NotificationException;
import Marionette from 'marionette';
import template from 'hbs!templates/notification/notification_exception';
import GlobalNotification from 'behaviors/global_notification';

export default NotificationException = (function() {
  NotificationException = class NotificationException extends Marionette.ItemView {
    static initClass() {

      this.prototype.template = template;

      this.prototype.behaviors = {
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
  NotificationException.initClass();
  return NotificationException;
})();
