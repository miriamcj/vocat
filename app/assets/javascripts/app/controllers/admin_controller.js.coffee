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

    editCourse: (courseId) ->
      unless _.isNaN(parseInt(courseId))
        Vocat.addRegions({
          creatorEnrollment: '[data-region="creator-enrollment"]'
          evaluatorEnrollment: '[data-region="evaluator-enrollment"]'
        })

        @collections.creator.courseId = courseId
        @collections.evaluator.courseId = courseId

        creatorEnrollmentView = new EnrollmentLayout({courseId: courseId, collection: @collections.creator})
        evaluatorEnrollmentView = new EnrollmentLayout({courseId: courseId, collection: @collections.evaluator})

        Vocat.creatorEnrollment.show creatorEnrollmentView
        Vocat.evaluatorEnrollment.show evaluatorEnrollmentView
