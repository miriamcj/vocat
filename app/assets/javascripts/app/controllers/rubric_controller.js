/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import VocatController from 'controllers/vocat_controller';
import RubricLayoutView from 'views/rubric/rubric_layout';

export default class RubricController extends VocatController.extend({}) {

  new(courseId) {
    const view = new RubricLayoutView({courseId});
    return window.Vocat.main.show(view);
  }

  editWithoutCourse(rubricId) {
    const view = new RubricLayoutView({rubricId});
    return window.Vocat.main.show(view);
  }

  edit(courseId, rubricId) {
    const view = new RubricLayoutView({rubricId});
    return window.Vocat.main.show(view);
  }
};

