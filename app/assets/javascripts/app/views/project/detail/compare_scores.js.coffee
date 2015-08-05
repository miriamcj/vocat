define (require) ->
  Marionette = require('marionette')
  CompareScoresItem = require('views/project/detail/compare_scores_item')
  template = require('hbs!templates/project/detail/compare_scores')
  CompareScoresCollection = require('collections/compare_scores_collection')

  class CompareScoresView extends Marionette.CompositeView

    template: template,
    childView: CompareScoresItem,
    childViewContainer: '[data-behavior="child-view-container"]'

    ui: {
      leftSelect: '[data-behavior="left-compare"]'
      rightSelect: '[data-behavior="right-compare"]'
    }

    childViewOptions: () ->
      {
        left: @ui.leftSelect.val()
        right: @ui.rightSelect.val()
      }

    triggers: {
      'change @ui.leftSelect': "select:change"
      'change @ui.rightSelect': "select:change"
    }

    onSelectChange: () ->
      left = @ui.leftSelect.val()
      right = @ui.rightSelect.val()
      @collection.updateQueryParams(left, right)
      @collection.fetch({reset: true})

    initialize: (options) ->
      @options = options || {}
      @projectId = Marionette.getOption(@, 'projectId')
      @collection = new CompareScoresCollection([], {projectId: @projectId})

    onRender: () ->
      left = @ui.leftSelect.val()
      right = @ui.rightSelect.val()
      @collection.updateQueryParams(left, right)
      @collection.fetch()
      setTimeout(() =>
        @ui.leftSelect.chosen({
          disable_search_threshold: 1000
        })
        @ui.rightSelect.chosen({
          disable_search_threshold: 1000
        })
      , 0)
