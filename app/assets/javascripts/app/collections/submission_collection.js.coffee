define ['marionette', 'backbone', 'models/submission'], (Marionette, Backbone, SubmissionModel) ->

  class SubmissionCollection extends Backbone.Collection

    model: SubmissionModel

    initialize: (models, options) ->
      @options = options

    comparator: (submission) ->
      submission.get('project_name')
