define [
  'marionette', 'controllers/vocat_controller', 'collections/creator_collection', 'views/admin/creator_enrollment'
], (
  Marionette, VocatController, CreatorCollection, CreatorEnrollmentView
) ->

  class AdminController extends VocatController

    collections: {
      creator: new CreatorCollection([], {})
    }

    editCourse: (courseId) ->
      console.log 'called once'
      Vocat.addRegions({
        creatorEnrollment: '[data-region="creator-enrollment"]'
        evaluatorEnrollment: '[data-region="evaluator-enrollment"]'
      })
      @collections.creator.courseId = courseId
      creatorEnrollmentView = new CreatorEnrollmentView({courseId: courseId, collection: @collections.creator})
      Vocat.creatorEnrollment.show creatorEnrollmentView
      console.log 'done'
