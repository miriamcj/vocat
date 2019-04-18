/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import template from 'hbs!templates/group/save_notify';
import GlobalNotification from 'behaviors/global_notification';

export default class SaveNotify extends Marionette.ItemView {
  static initClass() {

    this.prototype.template = template;

    this.prototype.triggers = {
      'click [data-trigger="save"]': 'click:groups:save',
      'click [data-trigger="revert"]': 'click:groups:revert'

    };

    this.prototype.behaviors = {
      globalNotification: {
        behaviorClass: GlobalNotification
      }
    };
  }

  onClickGroupsSave() {
    this.collection.save();
    Vocat.vent.trigger('notification:empty');
    return Vocat.vent.trigger('error:add', {level: 'notice', lifetime: '3000', msg: 'Groups have been saved.'});
  }

  onClickGroupsRevert() {
    this.collection.each(group => group.revert());
    return Vocat.vent.trigger('notification:empty');
  }
};
