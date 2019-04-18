/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import VocatController from 'controllers/vocat_controller';
import GroupLayout from 'views/group/group_layout';
import UserCollection from 'collections/user_collection';
import GroupCollection from 'collections/group_collection';
let GroupController;

export default GroupController = (function() {
  GroupController = class GroupController extends VocatController {
    static initClass() {

      this.prototype.collections = {
        creator: new UserCollection([], {}),
        group: new GroupCollection([], {})
      };
    }

    index(courseId) {
      const view = new GroupLayout({courseId, collections: this.collections});
      return Vocat.main.show(view);
    }
  };
  GroupController.initClass();
  return GroupController;
})();

