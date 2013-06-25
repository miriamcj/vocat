define [
  'marionette',
  'hbs!templates/submission/submission_layout',
  'collections/submission_collection',
  'collections/annotation_collection',
  'views/submission/player',
  'views/submission/annotations',
  'views/submission/annotator',
  'views/submission/score',
  'views/submission/upload'
], (
  Marionette, template, SubmissionCollection, AnnotationCollection, PlayerView, AnnotationsView, AnnotatorView, ScoreView, UploadView
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

    createChildViews: () ->
      @children.player = new PlayerView({model: @submission, vent: @})
      @children.annotations = new AnnotationsView({model: @submission, collection: @collections.annotation, vent: @})
      @children.score = new ScoreView({model: @submission, collection: @collections.submission, vent: @})
      @children.upload = new UploadView({model: @submission, collection: @collections.submission, vent: @})

      if @submission.get('video_attachment_id')
        @children.annotator = new AnnotatorView({model: @submission, collection: @collections.annotation, vent: @})

      if @children.player then @player.show(@children.player)
      if @children.annotations then @annotations.show(@children.annotations)
      if @children.annotator then @annotator.show(@children.annotator)
      if @children.score then @score.show(@children.score)
      if @children.upload then @upload.show(@children.upload)

    onChangeVideoAttachmentId: (data) ->
      console.log 'onChangeVideoAttachmentId called'
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

      @listenTo(@collections.submission, 'sync', (event) =>
        @submission = @collections.submission.at(0)
        @listenTo(@submission, 'change:video_attachment_id', (data) -> @onChangeVideoAttachmentId(data))
        @triggerMethod('submission:loaded')
      )
      @collections.submission.fetch()

    onSubmissionLoaded: () ->
      @collections.annotation.attachmentId = @submission.get('video_attachment_id')

      @createChildViews()


#    @listenTo(@submissions, 'sync', () -> @render())

