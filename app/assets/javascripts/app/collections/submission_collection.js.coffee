define ['marionette', 'backbone', 'models/submission'], (Marionette, Backbone, SubmissionModel) ->

  class SubmissionCollection extends Backbone.Collection

    model: SubmissionModel

    initialize: (models, options) ->
      @options = options
      @courseId = Marionette.getOption(@, 'courseId')

    fetchByCourseAndUser: (courseId, userId, options = {}) ->
      options = {} unless _.isObject(options)
      options.url = "/api/v1/courses/#{courseId}/users/#{userId}/submissions"
      options.remove = false
      @fetch(options)

    fetchByCourseAndUserAndProject: (courseId, userId, projectId, options) ->
      options = {} unless _.isObject(options)
      options.url = "/api/v1/courses/#{courseId}/users/#{userId}/projects/#{projectId}/submissions.json"
      options.remove = false
      @fetch(options)

    fetchByCourseAndGroupAndProject: (courseId, groupId, projectId, options) ->
      options = {} unless _.isObject(options)
      options.url = "/api/v1/courses/#{courseId}/groups/#{groupId}/projects/#{projectId}/submissions.json"
      options.remove = false
      @fetch(options)

    fetchByCourseAndGroup: (courseId, groupId, options) ->
      options = {} unless _.isObject(options)
      options.url = "/api/v1/courses/#{courseId}/groups/#{groupId}/submissions"
      options.remove = false
      @fetch(options)

    url: (options = {}) ->
      if @courseId?
        url = "/api/v1/courses/#{@courseId}/submissions"
      else
        throw {
          name:        "Submission Collection Error"
          message:     "Submission Collection must have a valid @courseId attribute."
        }

    comparator: (submission) ->
      submission.get('project_name')
