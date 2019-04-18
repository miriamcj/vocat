/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let EnrollmentEmptyCourses;
  const Marionette = require('marionette');
  const template = require('hbs!templates/admin/enrollment/empty_courses');

  return EnrollmentEmptyCourses = (function() {
    EnrollmentEmptyCourses = class EnrollmentEmptyCourses extends Marionette.ItemView {
      static initClass() {
  
        this.prototype.template = template;
        this.prototype.tagName = 'tr';
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
    EnrollmentEmptyCourses.initClass();
    return EnrollmentEmptyCourses;
  })();
});