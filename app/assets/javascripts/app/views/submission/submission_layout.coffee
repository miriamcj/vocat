define [
  'marionette',
  'hbs!templates/submission/submission_layout',
  'collections/submission_collection',
  'collections/annotation_collection',
  'views/submission/player',
  'views/submission/annotations',
  'views/submission/annotator',
  'views/submission/score',
  'views/submission/upload',
  'views/submission/upload/failed',
  'views/submission/upload/started',
  'views/submission/upload/transcoding',
  'views/submission/upload/start',
  'models/attachment',
  'app/plugins/backbone_poller',
], (
  Marionette, template, SubmissionCollection, AnnotationCollection, PlayerView, AnnotationsView, AnnotatorView, ScoreView, UploadView, UploadFailedView, UploadStartedView, UploadTranscodingView, UploadStartView, Attachment, Poller
) ->

  class SubmissionLayout extends Marionette.Layout

    template: template
    children: {}

    regions: {
      score: '[data-region="score"]'
      discussion: '[data-region="discussion"]'
      upload: '[data-region="upload"]'
      annotator: '[data-region="annotator"]'
      annotations: '[data-region="annotations"]'
      player: '[data-region="player"]'
    }

    onPlayerStop: () ->
      console.log 'heard a player stop request'

    onChangeVideoAttachmentId: (data) ->
      if @submission.get('video_attachment_id')
        @children.annotator = new AnnotatorView({model: @submission, collection: @collections.annotation, vent: @})
        @annotator.show(@children.annotator)

    initialize: (options) ->
      @options = options || {}

      @collections = options.collections
      @collections.annotation = new AnnotationCollection([],{})

      @courseId = Marionette.getOption(@, 'courseId')
      @project = Marionette.getOption(@, 'project')
      @creator = Marionette.getOption(@, 'creator')


      #@listenTo(@, 'all', (event) -> console.log(event))

      # Load the submission for this view
      @collections.submission = new SubmissionCollection([], {courseId: @courseId})

      @collections.submission.fetch({data: {project: @project.id, creator: @creator.id}, success: () =>

        @submission = @collections.submission.at(0)

        if @submission.get('current_user_can_annotate')
          if @submission.attachment? then attachmentId = @submission.attachment.id else attachmentId = null
          @annotations.show new AnnotationsView({model: @submission, attachmentId: attachmentId, collection: @collections.annotation, vent: @})

        if @submission.get('current_user_can_evaluate')
          @score.show new ScoreView({model: @project, collection: @collections.submission, vent: @})

        if @submission.get('current_user_can_attach')
          @upload.show new UploadView({model: @submission, collection: @collections.submission, vent: @})

        @getPlayerView()

        @triggerMethod('submission:loaded')
      })

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



