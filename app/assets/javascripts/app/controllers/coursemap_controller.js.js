define (require) ->
  VocatController = require('controllers/vocat_controller')
  UserCollection = require('collections/user_collection')
  ProjectCollection = require('collections/project_collection')
  SubmissionForCourseCollection = require('collections/submission_for_course_collection')
  GroupSubmissionCollection = require('collections/submission_for_group_collection')
  CourseUserSubmissionCollection = require('collections/submission_for_course_user_collection')
  GroupCollection = require('collections/group_collection')
  AssetCollection = require('collections/asset_collection')
  AssetDetail = require('views/assets/asset_detail')
  CourseMap = require('views/course_map/course_map')
  SubmissionDetail = require('views/submission/submission_layout')
  CreatorDetail = require('views/course_map/detail_creator')
  ProjectDetail = require('views/project/detail')
  ApplicationErrorView = require('views/error/application_error')
  AssetModel = require('models/asset')

  class CourseMapController extends VocatController

    collections: {
      user: new UserCollection([], {})
      group: new GroupCollection([], {})
      project: new ProjectCollection([], {})
      submission: new SubmissionForCourseCollection([], {})
      asset: new AssetCollection([], {})
    }

    layoutInitialized: false
    submissionsSynced: false

    initialize: () ->
      @bootstrapCollections()

    userCourseMap: (courseId) ->
      @_loadSubmissions(courseId)
      courseMap = new CourseMap({creatorType: 'User', courseId: courseId, collections: @collections})
      window.Vocat.main.show(courseMap)

    groupCourseMap: (courseId) ->
      @_loadSubmissions(courseId)
      courseMap = new CourseMap({creatorType: 'Group', courseId: courseId, collections: @collections})
      window.Vocat.main.show(courseMap)

    groupProjectDetail: (courseId, projectId) ->
      @_showProjectDetail(projectId, 'Group')

    userProjectDetail: (courseId, projectId) ->
      @_showProjectDetail(projectId, 'User')

    groupSubmissionDetail: (courseId, creatorId, projectId) ->
      @_showSubmissionDetail('Group', courseId, creatorId, projectId)

    groupSubmissionDetailAsset: (courseId, creatorId, projectId, assetId) ->
      @_showSubmissionDetail('Group', courseId, creatorId, projectId, assetId)

    userSubmissionDetail: (courseId, creatorId, projectId) ->
      @_showSubmissionDetail('User', courseId, creatorId, projectId)

    userSubmissionDetailAsset: (courseId, creatorId, projectId, assetId) ->
      @_showSubmissionDetail('User', courseId, creatorId, projectId, assetId)

    userCreatorDetail: (courseId, creatorId) ->
      @_showCreatorDetail('User', courseId, creatorId)

    groupCreatorDetail: (courseId, creatorId) ->
      @_showCreatorDetail('Group', courseId, creatorId)

    standaloneUserProjectDetail: (courseId, projectId) ->
      #TODO: Move standalone details into this controller

    assetDetail: (courseId, assetId) ->
      @_loadAsset(assetId).done((asset) =>
        assetDetail = new AssetDetail({
          courseId: courseId
          model: asset
          context: 'coursemap'
        })
        window.Vocat.main.show(assetDetail)
      )

    _loadAsset: (assetId) ->
      deferred = $.Deferred()
      asset = new AssetModel({id: assetId})
      asset.fetch({
        success: () ->
          deferred.resolve(asset)
      })
      deferred

    _loadSubmissions: (courseId) ->
      if @submissionsSynced == false
        @collections.submission.fetch({
          reset: true
          data: {course: courseId}
          error: () =>
            Vocat.vent.trigger('modal:open', new ModalErrorView({
              model: @model,
              vent: @,
              message: 'Exception: Unable to fetch collection models. Please report this error to your VOCAT administrator.',
            }))
          success: () =>
            @submissionsSynced = true
        })

    _loadOneSubmission: (creatorType, creatorId, projectId) ->
      deferred = $.Deferred()

      deferred.fail(@_handleSubmissionLoadError)

      # We don't deal in submission IDs in VOCAT (although I kind if wish we had), so we're fetching this
      # model outside of the usual collection/model framework. At some point, we may want to move this fetching
      # logic into a JS factory class or the submission model itself.
      $.ajax({
        url: "/api/v1/submissions/for_creator_and_project"
        method: 'get'
        data: {
          creator: creatorId
          project: projectId
          creator_type: creatorType
        }
        success: (data) =>
          if data.length > 0
            raw = _.find(data, (s) ->
              # It's possible to get two submissions back for an open project, so we need to grab the correct one.
              parseInt(s.creator.id) == parseInt(creatorId) && s.creator_type == creatorType
            )
            id = raw.id
            @collections.submission.add(raw, {merge: true})
            submission = @collections.submission.get(id)
            deferred.resolve(submission)
          else
            deferred.reject(creatorType, creatorId, projectId, null)
        error: (response) =>
          status = null
          if response? && response.status??
            status = response.status
          deferred.reject(creatorType, creatorId, projectId, status)
      })
      return deferred

    _handleSubmissionLoadError: (creatorType, creatorId, projectId, status) ->
      if status
        statusMsg = "When Vocat tried to load this submission, the server replied with a #{status} error."
      else
        statusMsg = "When Vocat tried to load this submission, the server did not return a valid submission."
      window.Vocat.main.show(new ApplicationErrorView({
        errorDetails: {
          description: "#{statusMsg} This means that the submission data is likely corrupted and needs to be repaired. \
            This error has been logged and reported to the vocat development team."
          code: "SUBMISSION-LOAD-FAILURE: CT#{creatorType}UID#{creatorId}PID#{projectId}"
        }
      }))

    _showSubmissionDetail: (creatorType, courseId, creatorId, projectId, assetId = null, courseMapContext = true) ->
      deferred = @_loadOneSubmission(creatorType, creatorId, projectId)
      deferred.done((submission) =>
        submissionDetail = new SubmissionDetail({
          collections: {submission: @collections.submission},
          courseId: courseId
          creator: creatorId
          project: projectId
          model: submission
          initialAsset: assetId
          courseMapContext: courseMapContext
        })
        window.Vocat.main.show(submissionDetail)
      )


    _showCreatorDetail: (creatorType, courseId, creatorId, courseMapContext = true) ->
      if creatorType == 'User'
        model = @collections.user.get(creatorId)
        collection = new CourseUserSubmissionCollection()
      else if creatorType == 'Group'
        model = @collections.group.get(creatorId)
        collection = new GroupSubmissionCollection()
      creatorDetail = new CreatorDetail({
        collection: collection
        courseId: courseId
        model: model
        courseMapContext: courseMapContext
      })
      window.Vocat.main.show(creatorDetail)

    _showProjectDetail: (projectId, creatorType, courseMapContext = true) ->
      model = @collections.project.get(projectId)
      projectDetail = new ProjectDetail({
        model: model
        creatorType: creatorType
        courseMapContext: courseMapContext
      })
      window.Vocat.main.show(projectDetail)
