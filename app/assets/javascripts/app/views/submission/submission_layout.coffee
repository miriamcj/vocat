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

      @courseId = Marionette.getOption(@, 'courseId')
      @project = Marionette.getOption(@, 'project')
      @creator = Marionette.getOption(@, 'creator')

      @collections.annotation = new AnnotationCollection([],{})



      @listenTo(@, 'all', (event) -> console.log(event))

      # Load the submission for this view
      @collections.submission = new SubmissionCollection([], {
        courseId: @courseId
        creatorId: @creator.id
        projectId: @project.id
      })

      @collections.submission.fetch({success: () =>

        @submission = @collections.submission.at(0)
        @collections.annotation.attachmentId = @submission.get('video_attachment_id')

#        @listenTo(@submission, 'change:video_attachment_id', (data) -> @onChangeVideoAttachmentId(data))

        @annotations.show new AnnotationsView({model: @submission, collection: @collections.annotation, vent: @})
        @score.show new ScoreView({model: @submission, collection: @collections.submission, vent: @})
        @upload.show new UploadView({model: @submission, collection: @collections.submission, vent: @})

        @getPlayerView()

        if @submission.attachment?
          @annotator.show new AnnotatorView({model: @submission, collection: @collections.annotation, vent: @})
        else

        @triggerMethod('submission:loaded')
      })

    startPolling: () ->
      options = {
        delay: 1000
        delayed: true
        condition: (attachment) =>
          console.log attachment, 'model'
          results = attachment.get('transcoding_success') == true
          console.log results
          if results
            @trigger('attachment:transcoding:completed')
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
        console.log @submission
        attachment = @submission.attachment
        if attachment.get('transcoding_busy') then @triggerMethod('attachment:upload:done')
        if attachment.get('transcoding_error') then @triggerMethod('attachment:transcoding:failed')
        if attachment.get('transcoding_success') then @triggerMethod('attachment:transcoding:completed')

    onAttachmentTranscodingCompleted: () ->
      console.log 'onAttachmentTranscoded'
      @player.show(new PlayerView({model: @submission.attachment, submission: @submission, vent: @}))

    onAttachmentUploadDone: () ->
      console.log 'onAttachmentUploadDone'
      @player.show(new UploadTranscodingView({}))
      console.log @submission,'before polling starts'
      @startPolling()

    onAttachmentDestroyed: () ->
      console.log 'onAttachmentUploadDeleted'
      @player.show(new UploadStartView({vent: @}))
      @annotator.close()

    onAttachmentUploadFailed: () ->
      console.log 'onAttachmentUploadFailed'
      @player.show(new UploadFailedView({}))

    onAttachmentUploadStarted: () ->
      console.log 'onAttachmentUploadStarted'
      @player.show(new UploadStartedView({}))




#    @listenTo(@submissions, 'sync', () -> @render())

