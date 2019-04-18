/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define([
  'marionette', 'controllers/vocat_controller', 'views/group/group_layout', 'collections/user_collection',
  'collections/group_collection'
], function(Marionette, VocatController, GroupLayout, UserCollection, GroupCollection) {
  let GroupController;
  return GroupController = (function() {
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
});

