define (require) ->

  marionette = require('marionette')
  VocatController = require('controllers/vocat_controller')
  EnrollmentCollection = require('collections/enrollment_collection')
  EnrollmentLayout = require('views/admin/enrollment_layout')
  ProjectCollection = require('collections/project_collection')
  Projects = require('views/course/manage/projects/projects')

  class CourseController extends VocatController

    collections: {
      project: new ProjectCollection([])
    }

    initialize: () ->
      @bootstrapCollections()

    creatorEnrollment: (courseId) ->
      unless _.isNaN(parseInt(courseId))
        Vocat.addRegions({
          creatorEnrollment: '[data-region="creator-enrollment"]'
        })
        view = new EnrollmentLayout({collection: new EnrollmentCollection([], {scope: {course: courseId, role: 'creator'}})})
        Vocat.creatorEnrollment.show view


    courseManageProjects: (courseId) ->
      unless _.isNaN(parseInt(courseId))
        Vocat.addRegions({
          projects: '[data-region="projects"]'
        })
        view = new Projects({collection: @collections.project})
        Vocat.projects.show view
