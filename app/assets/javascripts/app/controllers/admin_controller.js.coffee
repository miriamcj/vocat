define [
  'marionette', 'controllers/vocat_controller', 'collections/enrollment_collection', 'views/admin/enrollment_layout'
], (Marionette, VocatController, EnrollmentCollection, EnrollmentLayout) ->
  class AdminController extends VocatController

    collections: {
    }

    evaluatorEnrollment: (courseId) ->
      unless _.isNaN(parseInt(courseId))
        Vocat.addRegions({
          evaluatorEnrollment: '[data-region="evaluator-enrollment"]'
        })
        view = new EnrollmentLayout({
          collection: new EnrollmentCollection([], {scope: {course: courseId, role: 'evaluator'}})
        })
        Vocat.evaluatorEnrollment.show view

    assistantEnrollment: (courseId) ->
      unless _.isNaN(parseInt(courseId))
        Vocat.addRegions({
          assistantEnrollment: '[data-region="assistant-enrollment"]'
        })
        view = new EnrollmentLayout({
          collection: new EnrollmentCollection([], {scope: {course: courseId, role: 'assistant'}})
        })
        Vocat.assistantEnrollment.show view

    creatorEnrollment: (courseId) ->
      unless _.isNaN(parseInt(courseId))
        Vocat.addRegions({
          creatorEnrollment: '[data-region="creator-enrollment"]'
        })
        view = new EnrollmentLayout({
          collection: new EnrollmentCollection([], {scope: {course: courseId, role: 'creator'}})
        })
        Vocat.creatorEnrollment.show view

    courseEnrollment: (userId) ->
      unless _.isNaN(parseInt(userId))
        Vocat.addRegions({
          creatorEnrollment: '[data-region="creator-enrollment"]'
        })
        view = new EnrollmentLayout({collection: new EnrollmentCollection([], {scope: {user: userId}})})
        Vocat.creatorEnrollment.show view
