define [
  'marionette', 'controllers/vocat_controller', 'views/group/group_layout', 'collections/user_collection',
  'collections/group_collection'
], (Marionette, VocatController, GroupLayout, UserCollection, GroupCollection) ->
  class GroupController extends VocatController

    collections: {
      creator: new UserCollection([], {})
      group: new GroupCollection([], {})
    }

    index: (courseId) ->
      view = new GroupLayout({courseId: courseId, collections: @collections})
      Vocat.main.show view

