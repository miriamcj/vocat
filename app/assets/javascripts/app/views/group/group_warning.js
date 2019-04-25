/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import template from 'templates/group/group_warning.hbs';

export default class GroupWarning extends Marionette.ItemView.extend({
  template: template,

  triggers: {
    'click @ui.createGroup': 'click:group:add'
  },

  ui: {
    createGroup: '[data-behavior="create-group"]'
  }
}) {
  onClickGroupAdd() {
    return this.vent.triggerMethod('click:group:add');
  }

  initialize(options) {
    return this.vent = options.vent;
  }

  serializeData() {
    return {
    courseId: Marionette.getOption(this, 'courseId')
    };
  }
};
