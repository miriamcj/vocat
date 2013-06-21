define [
  'marionette', 'hbs!templates/submission/submission_layout', 'collections/submission_collection', 'views/submission/player'
], (
  Marionette, template, SubmissionCollection, PlayerView
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

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')
      @project = Marionette.getOption(@, 'project')
      @creator = Marionette.getOption(@, 'creator')

      @submissions = new SubmissionCollection([], {
        courseId: @courseId
        creatorId: @creator.id
        projectId: @project.id
      })

      @submissions.fetch({
        success: =>
          @submission = @submissions.at(0)
      })

      @listenTo(@submissions, 'sync', () -> @render())

      @children.player = new PlayerView({model: @submission})
#      @children.score = new ScoreView({model: @submission})
