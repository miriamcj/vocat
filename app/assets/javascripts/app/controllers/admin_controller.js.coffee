define [
  'marionette', 'controllers/vocat_controller', 'collections/creator_collection', 'collections/evaluator_collection', 'views/admin/enrollment_layout'
], (
  Marionette, VocatController, CreatorCollection, EvaluatorCollection, EnrollmentLayout
) ->

  class AdminController extends VocatController

    collections: {
      creator: new CreatorCollection([], {})
      evaluator: new EvaluatorCollection([], {})
    }

    manageEvaluators: (courseId) ->
      unless _.isNaN(parseInt(courseId))
        Vocat.addRegions({
          evaluatorEnrollment: '[data-region="evaluator-enrollment"]'
        })
        @collections.evaluator.courseId = courseId
        evaluatorEnrollmentView = new EnrollmentLayout({courseId: courseId, collection: @collections.evaluator})
        Vocat.evaluatorEnrollment.show evaluatorEnrollmentView

    manageCreators: (courseId) ->
      unless _.isNaN(parseInt(courseId))
        Vocat.addRegions({
          creatorEnrollment: '[data-region="creator-enrollment"]'
        })
        @collections.creator.courseId = courseId
        creatorEnrollmentView = new EnrollmentLayout({courseId: courseId, collection: @collections.creator})
        Vocat.creatorEnrollment.show creatorEnrollmentView
