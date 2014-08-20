define [
  'marionette', 'controllers/vocat_controller', 'collections/enrollment_collection', 'views/admin/enrollment_layout'
], (
  Marionette, VocatController, EnrollmentCollection, EnrollmentLayout
) ->

  class CourseController extends VocatController

    collections: {
    }

    creatorEnrollment: (courseId) ->
      unless _.isNaN(parseInt(courseId))
        Vocat.addRegions({
          creatorEnrollment: '[data-region="creator-enrollment"]'
        })
        view = new EnrollmentLayout({collection: new EnrollmentCollection([], {scope: {course: courseId, role: 'creator'}})})
        Vocat.creatorEnrollment.show view
