define (require) ->

  Backbone = require('backbone')
  VideoModel = require('models/video')
  EvaluationModel = require('models/evaluation')
  ProjectModel = require('models/project')
  UserModel = require('models/user')
  GroupModel = require('models/group')
  AssetCollection = require('collections/asset_collection')

  class SubmissionModel extends Backbone.Model

    assetCollection : null

    urlRoot: () ->
      '/api/v1/submissions'

    updateUrl: () ->
      "#{@urlRoot()}/#{@id}"

    requestTranscoding: () ->

    destroyVideo: () ->
      @video.destroy({success: () =>
        @set('video', null)
        @fetch({url: @updateUrl()})
      })

    toJSON: () ->
      json = super()
      if @video
        json.video= @video.toJSON()
      else
        json.video = null
      json

    getVideoId: () ->
      if @video? && @video.id?
        @video.id
      else
        null

    updateVideo: () ->
      rawVideo = @.get('video')
      if rawVideo?
        @video = new VideoModel(rawVideo)

    hasVideo: () ->
      @.get('video')?

    publishEvaluation: () ->
      @set('current_user_published', true)
      evaluationData = _.findWhere(@get('evaluations'), {current_user_is_evaluator: true})
      evaluation = new EvaluationModel(evaluationData)
      evaluation.save({published: true})

    unpublishEvaluation: () ->
      @set('current_user_published', false)
      evaluationData = _.findWhere(@get('evaluations'), {current_user_is_evaluator: true})
      evaluation = new EvaluationModel(evaluationData)
      evaluation.save({published: false})

    unsetMyEvaluation: () ->
      @set('current_user_has_evaluated',true)
      @set('current_user_percentage',0)
      @set('current_user_evaluation_published',false)

    toggleEvaluationPublish: () ->
      promise = $.Deferred()
      promise.then( () =>
        if @.get('current_user_published') == true
          @unpublishEvaluation()
        else if @.get('current_user_published') == false
          @publishEvaluation()
      )

      if @get('serialized_state') == 'partial'
        @fetch({success: () =>
          promise.resolve()
        })
      else
        promise.resolve()

    assets: () ->
      @assetCollection

    detailUrl: (courseId = false) ->
      if !courseId
        p = @get('project')
        courseId = p.course_id
      ct = @get('creator_type')
      if ct == 'User'
        creatorTypeSegment = 'users'
      else
        creatorTypeSegment = 'groups'
      cid = @get('creator_id')
      pid = @get('project_id')
      url = "/courses/#{courseId}/#{creatorTypeSegment}/evaluations/creator/#{cid}/project/#{pid}"
      url

    project: () ->
      if !@projectModel?
        @projectModel = new ProjectModel(@get('project'))
      @projectModel

    creator: () ->
      if !@creatorModel?
        if @get('creator_type') == 'User'
          @creatorModel = new UserModel(@get('creator'))
        else if @get('creator_type') == 'Group'
          @creatorModel = new GroupModel(@get('creator'))
        else
          @creatorModel = null
      @creatorModel

    initialize: () ->

      @listenTo(@, 'change:video', () =>
        @updateVideo()
      )
      @updateVideo()

      @listenTo(@, 'sync change', () =>
        @updateAssetsCollection()
      )
      @updateAssetsCollection()

    updateAssetsCollection: () ->
      if !@assetCollection
        @assetCollection = new AssetCollection(@get('assets'), {submissionId: @id})
      else
        @assetCollection.reset(@get('assets'))
