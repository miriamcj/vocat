define (require) ->

  SubmissionCollection = require('collections/submission_collection')

  class SubmissionForGroupCollection extends SubmissionCollection

    url: '/api/v1/submissions/for_group'
