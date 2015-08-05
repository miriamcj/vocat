define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/project/detail')
  ProjectScoreOverviewView = require('views/project/detail/project_score_overview')
  ProjectMediaOverviewView = require('views/project/detail/project_media_overview')
  CompareScoresView = require('views/project/detail/compare_scores')
  ProjectSubmissionListView = require('views/project/detail/project_submission_list')
  ProjectStatisticsModel = require('models/project_statistics')

  class ProjectDetail extends Marionette.LayoutView

    template: template

    regions: {
      projectMediaOverview: '[data-region="project-media-overview"]'
      projectScoreOverview: '[data-region="project-score-overview"]'
      projectsubmissionlist: '[data-region="project-submission-list"]'
      comparescores: '[data-region="project-compare-scores"]'
    }

    triggers: {
    }

    ui: {
    }

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @creatorType = Marionette.getOption(@, 'creatorType')
      @projectId = Marionette.getOption(@, 'projectId') || @model.id
      @projectStatisticsModel = new ProjectStatisticsModel({id: @projectId})
      @projectStatisticsModel.fetch({reset: true})

    serializeData: () ->
      {
        project: @model.toJSON()
      }

    onRender: () ->
      @projectId = Marionette.getOption(@, 'projectId')
      @projectScoreOverview.show(new ProjectScoreOverviewView({model: @projectStatisticsModel}))
      @projectMediaOverview.show(new ProjectMediaOverviewView({model: @projectStatisticsModel}))
      @comparescores.show(new CompareScoresView({projectId: @model.id}))
      @projectsubmissionlist.show(new ProjectSubmissionListView({projectId: @model.id}))