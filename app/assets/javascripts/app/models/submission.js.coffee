define (require) ->

  Backbone = require('backbone')
  VideoModel = require('models/video')
  EvaluationModel = require('models/evaluation')

  class SubmissionModel extends Backbone.Model

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
      console.log @.get('video')?, 'have I a video?'
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

    initialize: () ->
      @listenTo(@, 'change:video', () =>
        @updateVideo()
      )
      @updateVideo()
