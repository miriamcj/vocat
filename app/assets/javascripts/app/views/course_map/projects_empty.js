/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/course_map/projects_empty.hbs';

export default class CourseMapProjectsEmptyView extends Marionette.ItemView.extend({
  tagName: 'th',
  template: template,

  attributes: {
    'data-behavior': 'navigate-project',
    'data-match-height-source': ''
  }
}) {
  initialize(options) {
    return this.courseId = options.courseId;
  }

  serializeData() {
    return {
    courseId: this.courseId,
    isCreator: window.VocatUserRole === 'creator'
    };
  }
};
