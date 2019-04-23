/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import template from 'templates/course_map/warning.hbs';

export default class Warning extends Marionette.ItemView {
  constructor(options) {
    super(options);

    this.template = template;
  }

  serializeData() {
    const out = {
      isCreatorWarning: Marionette.getOption(this, 'warningType') === 'Creator',
      isProjectWarning: Marionette.getOption(this, 'warningType') === 'Project',
      isCreatorTypeGroup: Marionette.getOption(this, 'creatorType') === 'Group',
      isCreatorTypeUser: Marionette.getOption(this, 'creatorType') === 'User',
      creatorType: Marionette.getOption(this, 'creatorType'),
      warningType: Marionette.getOption(this, 'warningType'),
      courseId: Marionette.getOption(this, 'courseId'),
      canUpdateCourse: (window.VocatUserCourseRole === 'administrator') || (window.VocatUserCourseRole === 'evaluator')
    };
    return out;
  }
};
