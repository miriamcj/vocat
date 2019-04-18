/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let GroupsView;
const Marionette = require('marionette');
const template = require('hbs!templates/submission/evaluations/save_notify');
const GlobalNotification = require('behaviors/global_notification');

export default GroupsView = (function() {
  GroupsView = class GroupsView extends Marionette.ItemView {
    static initClass() {

      this.prototype.template = template;

      this.prototype.triggers = {
        'click [data-trigger="save"]': 'click:evaluation:save',
        'click [data-trigger="revert"]': 'click:evaluation:revert'
      };

      this.prototype.behaviors = {
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
  GroupsView.initClass();
  return GroupsView;
})();
