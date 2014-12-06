define (require) ->

  Marionette = require('marionette')
  VocatController = require('controllers/vocat_controller')
  CreatorDetailView = require('views/course_map/detail_creator')
  SubmissionLayoutView = require('views/submission/submission_layout')
  CourseUserSubmissionCollection = require('collections/submission_for_course_user_collection')
  GroupSubmissionCollection = require('collections/submission_for_group_collection')
  ProjectCollection = require('collections/project_collection')
  UserCollection = require('collections/user_collection')
  GroupCollection = require('collections/group_collection')
  AssetCollection = require('collections/asset_collection')
  AssetShowLayout = require('views/assets/asset_show_layout')


  class SubmissionController extends VocatController

    collections: {
      user: new UserCollection({})
      group: new GroupCollection({}, {courseId: null})
      project: new ProjectCollection({})
      asset: new AssetCollection({})
    }

    creatorDetail: (course, creator) ->
      userModel = @collections.user.first()
      view = new CreatorDetailView({
        courseId: course
        model: userModel
        collection: new CourseUserSubmissionCollection()
        standalone: true
      })
      window.Vocat.main.show(view)

    groupDetail: (course, creator) ->
      groupModel = @collections.group.first()
      view = new CreatorDetailView({
        courseId: course
        model: groupModel
        collection: new GroupSubmissionCollection()
        standalone: true
      })
      window.Vocat.main.show(view)

    creatorProjectDetail: (course, creator, project) ->
      userModel = @collections.user.first()
      projectModel = @collections.project.first()
      collection = new CourseUserSubmissionCollection()
      deferred = @deferredCollectionFetching(collection, {course: course, user: creator, project: project}, 'Loading submission...')
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

    assetShow: (course, asset) ->
      assetModel = @collections.asset.first()
      view = new AssetShowLayout({
        courseId: course
        model: assetModel
        collection: @collections.asset
        standalone: true
      })
      window.Vocat.main.show(view)

