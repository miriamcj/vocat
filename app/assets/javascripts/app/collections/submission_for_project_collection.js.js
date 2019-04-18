define (require) ->
  SubmissionCollection = require('collections/submission_collection')

  class SubmissionForProjectCollection extends SubmissionCollection

    url: '/api/v1/submissions/for_project'
