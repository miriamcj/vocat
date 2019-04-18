/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let ClosesOnUserAction;
  const Marionette = require('marionette');

  return ClosesOnUserAction = (function() {
    ClosesOnUserAction = class ClosesOnUserAction extends Marionette.Behavior {
      static initClass() {
  
        this.prototype.defaults = {
          closeMethod: 'close'
        };
  
        this.prototype.triggers = {
        };
  
        this.prototype.ui = {
        };
      }

      initialize() {
        return this.globalChannel = Backbone.Wreqr.radio.channel('global');
      }

      onOpened() {
        this.globalChannel.vent.trigger('user:action');
        return this.listenTo(this.globalChannel.vent, 'user:action', event => {
          if (!event || !$.contains(this.el, event.target)) {
            return this.view[this.defaults.closeMethod]();
          }
        });
      }

      onClosed() {
        return this.stopListening(this.globalChannel.vent, 'user:action');
      }
    };
    ClosesOnUserAction.initClass();
    return ClosesOnUserAction;
  })();
});
