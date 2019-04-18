/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import template from 'hbs!templates/admin/enrollment/empty_courses';

export default class EnrollmentEmptyCourses extends Marionette.ItemView {
  constructor() {

    this.template = template;
    this.tagName = 'tr';
  }

  serializeData() {
    return {
    colspan: 4
    };
  }

  onShow() {
    return this.$el.find('th').attr('colspan', this.$el.closest('table').find('thead th').length);
  }
};
