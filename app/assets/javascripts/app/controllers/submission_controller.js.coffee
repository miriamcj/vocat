define [
  'marionette', 'controllers/vocat_controller', 'views/submission/submission_layout', 'collections/submission_for_course_user_collection', 'collections/project_collection', 'collections/user_collection'
], (
  Marionette, VocatController, SubmissionLayoutView, SubmissionCollection, ProjectCollection, UserCollection
) ->

  class SubmissionController extends VocatController

    collections: {
      user: new UserCollection({})
      submission: new SubmissionCollection({})
      project: new ProjectCollection({})
    }

    creatorProjectDetail: (course, creator, project) ->
      deferred = @deferredCollectionFetching(@collections.submission, {course: course, user: creator}, 'Loading submission...')
      $.when(deferred).then(() =>
        submission = @collections.submission.findWhere({creator_type: 'User', creator_id: parseInt(creator), project_id: parseInt(project)})
        view = new SubmissionLayoutView({
          courseId: course
          collections: @collections
          creator: @collections.user.first()
          model: submission
          project: @collections.project.first()
        })

        window.Vocat.main.show(view)
      )

