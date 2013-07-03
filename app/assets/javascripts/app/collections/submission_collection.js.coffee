define ['backbone', 'models/submission'], (Backbone, SubmissionModel) ->

  class SubmissionCollection extends Backbone.Collection

    model: SubmissionModel

    initialize: (models, options) ->
      if options?
        if options.projectId? then @projectId = options.projectId
        if options.creatorId? then @creatorId = options.creatorId
        if options.courseId? then @courseId = options.courseId

    url: () ->
      "/api/v1/courses/#{@courseId}/submissions"
