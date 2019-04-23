/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/submission/utility/utility.hbs';

export default class UtilityView extends Marionette.ItemView {
  constructor(options) {
    super(options);

    this.template = template;
  }

  initialize(options) {
    this.vent = Marionette.getOption(this, 'vent');
    return this.courseId = Marionette.getOption(this, 'courseId');
  }

  serializeData() {
    const data = super.serializeData();
    data.courseId = this.courseId;
    return data;
  }
};
