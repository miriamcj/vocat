/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import template from 'templates/group/warning.hbs';

export default class Warning extends Marionette.ItemView {
  constructor() {

    this.template = template;
  }

  serializeData() {
    return {
    courseId: Marionette.getOption(this, 'courseId')
    };
  }
};