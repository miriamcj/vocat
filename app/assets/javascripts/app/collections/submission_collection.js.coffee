define ['marionette', 'backbone', 'models/submission'], (Marionette, Backbone, SubmissionModel) ->

  class SubmissionCollection extends Backbone.Collection

    model: SubmissionModel

    initialize: (models, options) ->
      @options = options
      @courseId = Marionette.getOption(@, 'courseId')

    url: () ->
      "/api/v1/courses/#{@courseId}/submissions"
