/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let NotificationException;
  const Marionette = require('marionette');
  const template = require('hbs!templates/notification/notification_exception');
  const GlobalNotification = require('behaviors/global_notification');

  return NotificationException = (function() {
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
});
