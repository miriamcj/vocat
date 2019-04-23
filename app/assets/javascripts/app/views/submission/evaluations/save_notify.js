/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/submission/evaluations/save_notify.hbs';
import GlobalNotification from 'behaviors/global_notification';

export default class GroupsView extends Marionette.ItemView {
  constructor(options) {
    super(options);

    this.template = template;

    this.triggers = {
      'click [data-trigger="save"]': 'click:evaluation:save',
      'click [data-trigger="revert"]': 'click:evaluation:revert'
    };

    this.behaviors = {
      globalNotification: {
        behaviorClass: GlobalNotification
      }
    };
  }

  initialize(options) {
    return this.vent = options.vent;
  }

  onClickEvaluationSave() {
    Vocat.vent.trigger('notification:empty');
    return this.vent.triggerMethod('evaluation:save');
  }

  onClickEvaluationRevert() {
    Vocat.vent.trigger('notification:empty');
    return this.vent.triggerMethod('evaluation:revert');
  }
};
