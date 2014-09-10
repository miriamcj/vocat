define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/project/detail')
  RubricModel = require('models/rubric')
  ProjectModel = require('models/project')
  SummaryView = require('views/project/detail/summary')
  CrossfilteredView = require('views/project/detail/crossfiltered')
  NoScoresView = require('views/project/detail/no_scores')
  d3 = require('vendor/d3/d3')
  dc = require('vendor/dc/dc')
  crossfilter = require('vendor/crossfilter/crossfilter')

  class CourseMapDetailProject extends Marionette.LayoutView

    loadedScoresSet = null
    template: template

    regions: {
      summary: '[data-region="project-summary"]'
      crossfiltered: '[data-region="project-crossfiltered"]'
    }

    triggers: {
      'change [data-behavior="score-set-select"]': 'change:score:set'
    }

    ui: {
      scoreSetSelect: '[data-behavior="score-set-select"]'
    }

    initialize: (options) ->

      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')

      if @model
        # Viewed in coursemap
        @projectId = @model.id
      else
        # Stand alone view
        @projectId = Marionette.getOption(@, 'projectId')

      # The layout is responsible for loading the data and passing it to its component views when it's been updated.
      $.when(@scoresLoaded(), @projectLoaded()).then(() =>
        @updateViews()
      )

    updateViews: () ->
      @render()
      @summary.show new SummaryView({summary: @data.summary, vent: @vent})
      if @data.scores.length == 0
        @crossfiltered.show new NoScoresView({loadedScoresSet: @loadedScoresSet, vent: @vent})
      else
        @crossfiltered.show new CrossfilteredView({scores: @data.scores, rubric: @rubric, vent: @vent})

    onChangeScoreSet: () ->
      set = @ui.scoreSetSelect.val()
      $.when(@scoresLoaded(set)).then(() =>
        @updateViews()
      )

    onRender: () ->
      @ui.scoreSetSelect.chosen({
        disable_search_threshold: 1000
      })

    projectLoaded: () ->
      deferred = $.Deferred()
      resolve = () =>
        @rubric = new RubricModel(@model.get('rubric'))
        deferred.resolve()
      unless @model?
        @model = new ProjectModel({id: @projectId})
        @model.fetch({success: resolve})
      else
        resolve()
      deferred

    serializeData: () ->
      out = {
        loadedScoresSet: @loadedScoresSet
      }
      out

    scoresLoaded: (set = 'my_scores') ->
      @loadedScoresSet = set
      deferred = $.Deferred()
      $.ajax("/api/v1/scores/#{set}",{
        dataType: 'json'
        data: {
          project: @projectId
        }
        success: (data, textStatus, jqXHR) =>
          @data = data
          deferred.resolve()
      })
      deferred
