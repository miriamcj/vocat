define (require) ->
  VocatController = require('controllers/vocat_controller')
  UserCollection = require('collections/user_collection')
  ProjectCollection = require('collections/project_collection')
  ProjectDetail = require('views/project/detail')
  ApplicationErrorView = require('views/error/application_error')

  class ProjectController extends VocatController

    collections: {
      user: new UserCollection([], {})
      project: new ProjectCollection([], {})
    }

    layoutInitialized: false
    submissionsSynced: false

    initialize: () ->
      @bootstrapCollections()

    groupProjectDetail: (courseId, projectId) ->
      @_showProjectDetail(projectId, 'Group')

    userProjectDetail: (courseId, projectId) ->
      @_showProjectDetail(projectId, 'User')

    _showProjectDetail: (projectId, creatorType, courseMapContext = true) ->
      model = @collections.project.get(projectId)
      projectDetail = new ProjectDetail({
        model: model
        creatorType: creatorType
        courseMapContext: courseMapContext
      })
      window.Vocat.main.show(projectDetail)