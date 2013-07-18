define [
  'marionette',
  'hbs!templates/submission/submission_layout',
  'collections/submission_collection',
  'collections/annotation_collection',
  'collections/evaluation_collection',
  'views/submission/player',
  'views/submission/annotations',
  'views/submission/annotator',
  'views/submission/evaluation',
  'views/submission/my_evaluation',
  'views/submission/upload',
  'views/submission/upload/failed',
  'views/submission/upload/started',
  'views/submission/upload/transcoding',
  'views/submission/upload/start',
  'views/flash/flash_messages',
  'models/attachment',
  'app/plugins/backbone_poller'
], (
  Marionette, template, SubmissionCollection, AnnotationCollection, EvaluationCollection, PlayerView, AnnotationsView, AnnotatorView, EvaluationView, MyEvaluationView, UploadView, UploadFailedView, UploadStartedView, UploadTranscodingView, UploadStartView, FlashMessagesView, Attachment, Poller
) ->

  class SubmissionLayout extends Marionette.Layout

    template: template
    children: {}

    regions: {
      flash: '[data-region="flash"]'
      evaluations: '[data-region="evaluations"]'
      myEvaluation: '[data-region="my-evaluation"]'
      discussion: '[data-region="discussion"]'
      upload: '[data-region="upload"]'
      annotator: '[data-region="annotator"]'
      annotations: '[data-region="annotations"]'
      player: '[data-region="player"]'
    }

    onPlayerStop: () ->
      # do something

    onChangeVideoAttachmentId: (data) ->
      if @submission.get('video_attachment_id')
        @children.annotator = new AnnotatorView({model: @submission, collection: @collections.annotation, vent: @})
        @annotator.show(@children.annotator)

    onSubmissionFound: () ->
      @submission.fetch({
        success: () =>
          @triggerMethod('submission:loaded')
      })

    onSubmissionLoaded: () ->
      @createEvaluationViews()
      @createAnnotationView()
      @createUploadView()
      @createFlashView()
      @createPlayerView()

    initialize: (options) ->
      @options = options || {}
      @collections = options.collections
      @collections.annotation = new AnnotationCollection([],{})

      @courseId = Marionette.getOption(@, 'courseId')
      @project = Marionette.getOption(@, 'project')
      @creator = Marionette.getOption(@, 'creator')

      # Load the submission for this view and then instantiate all child views
      @submission = @collections.submission.findWhere({project_id: @project.id, creator_id: @creator.id})
      if !@submission
        temporaryCollection = new SubmissionCollection([], {courseId: @courseId})
        temporaryCollection.fetch({data: {project: @project.id, creator: @creator.id}, success: () =>
          @submission = temporaryCollection.pop()
          @collections.submission.add(@submission)
          @triggerMethod('submission:found')
        })
      else
        @triggerMethod('submission:found')

    createEvaluationViews: () ->
      evaluations = new EvaluationCollection(@submission.get('evaluations'), {courseId: @courseId})
      if @submission.get('current_user_can_evaluate') == true
        myEvaluation = evaluations.findWhere({current_user_is_owner: true})
        if myEvaluation
          models = [myEvaluation]
        else
          models = []
        evaluations.remove(myEvaluation)
        myEvaluations = new EvaluationCollection(models, {courseId: @courseId})
        @myEvaluation.show new MyEvaluationView({collection: myEvaluations, model: @submission, project: @project, vent: @, courseId: @courseId})
      @evaluations.show new EvaluationView({collection: evaluations, model: @submission, project: @project, vent: @, courseId: @courseId})

    createAnnotationView: () ->
      # Create the annotations view
      if @submission.get('current_user_can_annotate')
        if @submission.attachment? then attachmentId = @submission.attachment.id else attachmentId = null
        @annotations.show new AnnotationsView({model: @submission, attachmentId: attachmentId, collection: @collections.annotation, vent: @})

    createUploadView: () ->
      # Create the upload view
      if @submission.get('current_user_can_attach')
        @upload.show new UploadView({model: @submission, collection: @collections.submission, vent: @})

    createFlashView: () ->
      # Create the flash messages view
      @flash.show new FlashMessagesView({vent: @, clearOnAdd: true})

    createPlayerView: () ->
      # Create the player view
      @getPlayerView()

    startPolling: () ->
      options = {
        delay: 1000
        delayed: true
        condition: (attachment) =>
          results = attachment.get('transcoding_success') == true
          if results
            @triggerMethod('attachment:transcoding:completed', {attachment: attachment})
            out = false
          else
            out = true
          out
      }
      poller = Poller.get(@submission.attachment, options);
      poller.start()

    getPlayerView: () ->
      if !@submission.attachment?
        @triggerMethod('attachment:destroyed')
      else
        attachment = @submission.attachment
        if attachment
          if attachment.get('transcoding_busy') then @triggerMethod('attachment:upload:done')
          if attachment.get('transcoding_error') then @triggerMethod('attachment:transcoding:failed')
          if attachment.get('transcoding_success') then @triggerMethod('attachment:transcoding:completed')

    onAttachmentTranscodingCompleted: (data) ->
      if data? && data.attachment?
        @collections.annotation.fetch({data: {attachment: data.attachment.id}})
      @player.show(new PlayerView({model: @submission.attachment, submission: @submission, vent: @}))
      @annotator.show new AnnotatorView({model: @submission, collection: @collections.annotation, vent: @})

    onAttachmentUploadDone: () ->
      @player.show(new UploadTranscodingView({}))
      @trigger('upload:close')
      @startPolling()

    onAttachmentDestroyed: () ->
      @collections.annotation.attachmentId = null
      @collections.annotation.reset()
      @player.show(new UploadStartView({vent: @}))
      @annotator.close()

    onAttachmentUploadFailed: () ->
      @player.show(new UploadFailedView({}))

    onAttachmentUploadStarted: () ->
      @player.show(new UploadStartedView({}))



