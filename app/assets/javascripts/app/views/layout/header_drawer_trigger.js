/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let HeaderDrawerTriggerView;
const Marionette = require('marionette');

export default HeaderDrawerTriggerView = class HeaderDrawerTriggerView extends Marionette.ItemView {

  onClickTrigger() {
    return this.globalChannel.vent.trigger(`drawer:${this.drawerTarget}:toggle`);
  }

  initialize(options) {
    this.globalChannel = Backbone.Wreqr.radio.channel('global');
    this.vent = options.vent;
    this.drawerTarget = this.$el.data().drawerTarget;
    return this.$el.on('click', e => {
      e.stopPropagation();
      return this.onClickTrigger();
    });
  }
};

