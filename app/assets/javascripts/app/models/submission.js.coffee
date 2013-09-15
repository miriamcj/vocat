define ['backbone', 'models/attachment', 'models/evaluation'], (Backbone, Attachment, EvaluationModel) ->

  class SubmissionModel extends Backbone.Model

    urlRoot: () ->
      '/api/v1/submissions'

    paramRoot: 'submission'

    requestTranscoding: () ->

    canBeAnnotated: () ->
      @get('current_user_can_annotate') == true && @get('has_transcoded_attachment') == true

    toJSON: () ->
      json = super()
      if @attachment?
        json.attachment = @attachment.toJSON()
      else
        json.attachment = null
      json

    updateAttachment: () ->
      rawAttachment = @.get('attachment')
      if rawAttachment?
        @attachment = new Attachment(rawAttachment)

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
      @listenTo(@, 'change:attachment', () =>
        @updateAttachment()
      )
      @updateAttachment()
