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

    triggers: () ->
      t = {
        'change [data-behavior="score-set-select"]': 'change:score:set'
      }
      if _.isFunction(@vent.triggerMethod)
        t['click @ui.close'] = 'close'
      t

    ui: {
      close: '[data-behavior="detail-close"]'
      scoreSetSelect: '[data-behavior="score-set-select"]'
    }

    onClose: () ->
      @vent.triggerMethod('close:detail') if _.isFunction(@vent.triggerMethod)

    initialize: (options) ->

      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')

      @projectId = Marionette.getOption(@, 'projectId') || @model.id

        # The layout is responsible for loading the data and passing it to its component views when it's been updated.
      $.when(@scoresLoaded(), @projectAndRubricLoaded()).then(() =>
        console.log 'CALLED B'
        @updateViews()
      ).fail((reason) =>
        @handleLoadFailure(reason)
      )

    handleLoadFailure: (reason) ->
      Vocat.vent.trigger('exception', reason)

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

    projectAndRubricLoaded: () ->
      projectLoadPromise = $.Deferred()
      rubricLoadPromise = $.Deferred()

      if @model?
        projectLoadPromise.resolve()
      else
        @model = new ProjectModel({id: @projectId})
        @model.fetch({success: () ->
          projectLoadPromise.resolve()
        , error: () =>
          projectLoadPromise.reject('Unable to load project data. Perhaps this project has been deleted?')
        })

      projectLoadPromise.then(() =>
        @rubric = new RubricModel({id: @model.get('rubric_id')})
        @rubric.fetch({success: () ->
          rubricLoadPromise.resolve()
        , error: () =>
          rubricLoadPromise.reject('Unable to load project rubric. Perhaps the rubric has been deleted?')
        })
      )
      rubricLoadPromise

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

    serializeData: () ->
      project = super()
      out = {
        loadedScoresSet: @loadedScoresSet
        project: project
      }
      out

