/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define([
  'marionette',
  'hbs!templates/notification/notification_message',
], function(Marionette, template) {
  let NotificationMessage;
  return NotificationMessage = (function() {
    NotificationMessage = class NotificationMessage extends Marionette.ItemView {
      static initClass() {
  
        this.prototype.template = template;
        this.prototype.lifetime = 10000;
        this.prototype.isFlash = true;
  
        this.prototype.triggers = {
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
    NotificationMessage.initClass();
    return NotificationMessage;
  })();
});

