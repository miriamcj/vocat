/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import template from 'hbs!templates/course_map/projects_empty';

export default CourseMapProjectsEmptyView = (function() {
  CourseMapProjectsEmptyView = class CourseMapProjectsEmptyView extends Marionette.ItemView {
    static initClass() {

      this.prototype.tagName = 'th';
      this.prototype.template = template;
      this.prototype.attributes = {
        'data-behavior': 'navigate-project',
        'data-match-height-source': ''
      };
    }

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
  CourseMapProjectsEmptyView.initClass();
  return CourseMapProjectsEmptyView;
})();

