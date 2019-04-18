/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import template from 'hbs!templates/group/group_warning';

export default class GroupWarning extends Marionette.ItemView {
  constructor() {

    this.template = template;

    this.triggers = {
      'click @ui.createGroup': 'click:group:add'
    };

    this.ui = {
      createGroup: '[data-behavior="create-group"]'
    };
  }

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
