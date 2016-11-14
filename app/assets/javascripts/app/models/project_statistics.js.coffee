define (require) ->
  Backbone = require('backbone')

  class ProjectStatisticsModel extends Backbone.Model

    scoreView: 'Project Scores'

    updateScoreView: (scoreView) ->
      this.attributes.scoreView = scoreView

    url: () ->
      "/api/v1/projects/#{@id}/statistics"