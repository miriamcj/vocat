/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import VocatController from 'controllers/vocat_controller';
import RubricLayoutView from 'views/rubric/rubric_layout';

export default RubricController = class RubricController extends VocatController {

  new(courseId) {
    const view = new RubricLayoutView({courseId});
    return Vocat.main.show(view);
  }

  editWithoutCourse(rubricId) {
    const view = new RubricLayoutView({rubricId});
    return Vocat.main.show(view);
  }

  edit(courseId, rubricId) {
    const view = new RubricLayoutView({rubricId});
    return Vocat.main.show(view);
  }
};

