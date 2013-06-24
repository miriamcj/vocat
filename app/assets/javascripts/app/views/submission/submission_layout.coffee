define [
  'marionette',
  'hbs!templates/submission/submission_layout',
  'collections/submission_collection',
  'collections/annotation_collection',
  'views/submission/player',
  'views/submission/annotations'
], (
  Marionette, template, SubmissionCollection, AnnotationCollection, PlayerView, AnnotationsView
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

    createChildViews: () ->
      @children.player = new PlayerView({model: @submission, vent: @})
      @children.annotations = new AnnotationsView({model: @submission, collection: @annotations, vent: @})
#      @children.score = new ScoreView({model: @submission})

    onRender: () ->
      if @children.player then @player.show(@children.player)
      if @children.annotations then @annotations.show(@children.annotations)

    initialize: (options) ->
      @options = options || {}

      @courseId = Marionette.getOption(@, 'courseId')
      @project = Marionette.getOption(@, 'project')
      @creator = Marionette.getOption(@, 'creator')

      @annotations = new AnnotationCollection([],{})

      # Load the submission for this view
      @submissions = new SubmissionCollection([], {
        courseId: @courseId
        creatorId: @creator.id
        projectId: @project.id
      })

      @listenTo(@submissions, 'sync', (event) =>
        @submission = @submissions.at(0)
        @triggerMethod('submission:loaded')
      )

      @submissions.fetch()

    onSubmissionLoaded: () ->
      @annotations.attachmentId = @submission.get('video_attachment_id')
      @createChildViews()


#    @listenTo(@submissions, 'sync', () -> @render())

