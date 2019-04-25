/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/group/save_notify.hbs';
import GlobalNotification from 'behaviors/global_notification';

export default class SaveNotify extends Marionette.ItemView.extend({
  template: template,

  triggers: {
    'click [data-trigger="save"]': 'click:groups:save',
    'click [data-trigger="revert"]': 'click:groups:revert'

  },

  behaviors: {
    globalNotification: {
      behaviorClass: GlobalNotification
    }
  }
}) {
  onClickGroupsSave() {
    this.collection.save();
    window.Vocat.vent.trigger('notification:empty');
    return window.Vocat.vent.trigger('error:add', {level: 'notice', lifetime: '3000', msg: 'Groups have been saved.'});
  }

  onClickGroupsRevert() {
    this.collection.each(group => group.revert());
    return window.Vocat.vent.trigger('notification:empty');
  }
};
