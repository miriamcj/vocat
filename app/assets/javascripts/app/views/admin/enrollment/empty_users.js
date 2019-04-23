/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/admin/enrollment/empty_users.hbs';

export default class EnrollmentEmptyUsers extends Marionette.ItemView {
  constructor(options) {
    super(options);

    this.template = template;
    this.tagName = 'tr';
  }

  serializeData() {
    return {
    colspan: 4,
    role: this.options.role
    };
  }

  onShow() {
    return this.$el.find('th').attr('colspan', this.$el.closest('table').find('thead th').length);
  }
};
