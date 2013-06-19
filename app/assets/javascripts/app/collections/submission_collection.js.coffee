define ['backbone', 'models/submission'], (Backbone, SubmissionModel) ->

  class SubmissionCollection extends Backbone.Collection

    model: SubmissionModel

    initialize: (models, options) ->
      if options?
        if options.projectId? then @projectId = options.projectId
        if options.creatorId? then @creatorId = options.creatorId
        if options.courseId? then @courseId = options.courseId

    url: () ->
      url = '/api/v1/'

      if @courseId
        url = url + "course/#{@courseId}/"

      if @creatorId
        url = url + "creator/#{@creatorId}/"

      if @projectId
        url = url + "project/#{@projectId}/"

      url + 'submissions'