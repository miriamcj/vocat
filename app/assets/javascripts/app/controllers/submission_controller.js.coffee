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

    # TODO: Remove this controller method when this static view is no longer needed
    helpDev: () ->
      @creatorProjectDetail(8, 67, 14)


    creatorProjectDetail: (course = null, creator = null, project = null) ->

      # The layout that contains the two lists of portfolio items
      submission = new SubmissionLayoutView({
        courseId: course
        collections: @collections
        creator: @collections.creator.get(creator)
        project: @collections.project.get(project)
        submission: @collections.submission.get(submission)
      })

      # Assign the collection views to the layout; assign the layout to the main region
      window.Vocat.main.show(submission)

