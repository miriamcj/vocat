/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/group/save_notify.hbs';
import GlobalNotification from 'behaviors/global_notification';

export default class SaveNotify extends Marionette.ItemView {
  constructor(options) {
    super(options);

    this.template = template;

    this.triggers = {
      'click [data-trigger="save"]': 'click:groups:save',
      'click [data-trigger="revert"]': 'click:groups:revert'

    };

    this.behaviors = {
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
