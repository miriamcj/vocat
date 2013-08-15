define [
  'marionette', 'controllers/vocat_controller', 'views/group/group_layout', 'collections/creator_collection', 'collections/group_collection'
], (
  Marionette, VocatController, GroupLayout, CreatorCollection, GroupCollection
) ->

  class GroupController extends VocatController

    collections: {
      creator: new CreatorCollection([], {})
      group: new GroupCollection([], {})
    }

    new: (courseId) ->
      view = new GroupLayout({courseId: courseId, collections: @collections})
      Vocat.main.show view

