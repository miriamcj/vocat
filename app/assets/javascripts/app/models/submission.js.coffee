define (require) ->

  Backbone = require('backbone')
  VideoModel = require('models/video')
  EvaluationModel = require('models/evaluation')

  class SubmissionModel extends Backbone.Model

    urlRoot: () ->
      '/api/v1/submissions'

    updateUrl: () ->
      "#{@urlRoot()}/#{@id}"

    paramRoot: 'submission'

    requestTranscoding: () ->

    canBeAnnotated: () ->
      @get('current_user_can_annotate') == true && @get('has_video') == true

    destroyVideo: () ->
      @video.destroy()
      @set('has_video',false)

    toJSON: () ->
      json = super()
      if @video
        json.video= @video.toJSON()
      else
        json.video = null
      json

    updateVideo: () ->
      rawVideo = @.get('video')
      if rawVideo?
        @video = new VideoModel(rawVideo)

    publishEvaluation: () ->
      evaluationData = @.get('current_user_evaluation')
      evaluation = new EvaluationModel(evaluationData)
      evaluation.save({published: true})
      @.set('current_user_evaluation_published', true)

    unpublishEvaluation: () ->
      evaluationData = @.get('current_user_evaluation')
      evaluation = new EvaluationModel(evaluationData)
      evaluation.save({published: false})
      @.set('current_user_evaluation_published', false)

    toggleEvaluationPublish: () ->
      evaluationData = @.get('current_user_evaluation')
      if evaluationData?
        if @.get('current_user_evaluation_published') == true
          @unpublishEvaluation()
        else
          @publishEvaluation()

    initialize: () ->
      @listenTo(@, 'change:video', () =>
        @updateVideo()
      )
      @updateVideo()
