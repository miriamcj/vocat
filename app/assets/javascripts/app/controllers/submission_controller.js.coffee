define [
  'marionette', 'controllers/vocat_controller', 'views/submission/submission_layout', 'collections/submission_for_course_user_collection', 'collections/submission_for_group_collection', 'collections/project_collection', 'collections/user_collection', 'collections/group_collection'
], (
  Marionette, VocatController, SubmissionLayoutView, CourseUserSubmissionCollection, GroupSubmissionCollection, ProjectCollection, UserCollection, GroupCollection
) ->

  class SubmissionController extends VocatController

    collections: {
      user: new UserCollection({})
      group: new GroupCollection({}, {courseId: null})
      project: new ProjectCollection({})
    }

    creatorProjectDetail: (course, creator, project) ->
      userModel = @collections.user.first()
      projectModel = @collections.project.first()
      collection = new CourseUserSubmissionCollection()
      deferred = @deferredCollectionFetching(collection, {course: course, user: creator}, 'Loading submission...')
      $.when(deferred).then(() =>
        submissionModel = collection.findWhere({creator_type: 'User', creator_id: parseInt(creator), project_id: parseInt(project)})
        view = new SubmissionLayoutView({
          courseId: course
          creator: userModel
          model: submissionModel
          project: projectModel
        })

        window.Vocat.main.show(view)
      )

    groupProjectDetail: (course, creator, project) ->
      groupModel = @collections.group.first()
      projectModel = @collections.project.first()
      collection = new GroupSubmissionCollection()
      deferred = @deferredCollectionFetching(collection, {course: course, group: creator}, 'Loading submission...')
      $.when(deferred).then(() =>
        submissionModel = collection.findWhere({creator_type: 'Group', creator_id: parseInt(creator), project_id: parseInt(project)})
        view = new SubmissionLayoutView({
          courseId: course
          creator: groupModel
          model: submissionModel
          project: projectModel
        })

        window.Vocat.main.show(view)
      )


