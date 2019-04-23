/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


export default class ClosesOnUserAction extends Marionette.Behavior {
  constructor(options) {
    super(...args);

    this.defaults = {
      closeMethod: 'close'
    };

    this.triggers = {
    };

    this.ui = {
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
