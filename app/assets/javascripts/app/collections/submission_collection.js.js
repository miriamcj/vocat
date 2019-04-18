define (require) ->
  Marionette = require('marionette')
  Backbone = require('backbone')
  SubmissionModel = require('models/submission')

  class SubmissionCollection extends Backbone.Collection

    model: SubmissionModel

    initialize: (models, options) ->
      @options = options

    comparator: (submission) ->
      submission.get('project_name')