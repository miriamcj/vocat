define [
  'marionette', 'controllers/vocat_controller', 'views/submission/submission_layout', 'collections/submission_collection', 'collections/project_collection', 'collections/user_collection'
], (
  Marionette, VocatController, SubmissionLayoutView, SubmissionCollection, ProjectCollection, UserCollection
) ->

  class SubmissionController extends VocatController

    collections: {
      user: new UserCollection({})
      submission: new SubmissionCollection({})
      project: new ProjectCollection({})
    }

    creatorProjectDetail: (course , project) ->
      # The layout that contains the two lists of portfolio items
      submission = new SubmissionLayoutView({
        courseId: course
        collections: @collections
        submission: @collections.submission.first()
        creator: @collections.user.first()
        project: @collections.project.first()
      })

      # Assign the collection views to the layout; assign the layout to the main region
      window.Vocat.main.show(submission)

