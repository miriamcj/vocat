define (require) ->

  SubmissionCollection = require('collections/submission_collection')

  class SubmissionForCourseCollection extends SubmissionCollection

    url: '/api/v1/submissions/for_course'
