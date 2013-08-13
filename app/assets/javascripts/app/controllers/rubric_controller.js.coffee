define [
  'marionette', 'controllers/vocat_controller', 'views/rubric/rubric_layout'
], (
  Marionette, VocatController, RubricLayoutView
) ->

  class RubricController extends VocatController

    new: (courseId) ->
      view = new RubricLayoutView({courseId: courseId})
      Vocat.main.show view

    editWithoutCourse: (rubricId) ->
      view = new RubricLayoutView({rubricId: rubricId})
      Vocat.main.show view

    edit: (courseId, rubricId) ->
      view = new RubricLayoutView({rubricId: rubricId})
      Vocat.main.show view

