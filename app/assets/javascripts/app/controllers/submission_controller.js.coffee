define [
  'marionette', 'controllers/vocat_controller', 'views/submission/submission_layout', 'collections/submission_collection', 'collections/project_collection', 'collections/creator_collection'
], (
  Marionette, VocatController, SubmissionLayoutView, SubmissionCollection, ProjectCollection, CreatorCollection
) ->

  class SubmissionController extends VocatController

    collections: {
      creator: new CreatorCollection({})
      submission: new SubmissionCollection({})
      project: new ProjectCollection({})
    }

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

