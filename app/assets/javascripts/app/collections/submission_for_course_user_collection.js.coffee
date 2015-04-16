define (require) ->
  SubmissionCollection = require('collections/submission_collection')

  class SubmissionForCourseUserCollection extends SubmissionCollection

    url: '/api/v1/submissions/for_course_and_user'
