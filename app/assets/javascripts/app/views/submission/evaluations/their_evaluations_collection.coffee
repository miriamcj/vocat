define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/their_evaluations_collection')
  ChildView = require('views/submission/evaluations/their_evaluations_child')
  ExpandableRange = require('behaviors/expandable_range')

  class TheirEvaluationsCollection extends Marionette.CompositeView

    template: template
    className: 'evaluation-collection'
    tagName: 'li'
    childView: ChildView
    childViewContainer: '[data-behavior="child-container"]:first'

    behaviors: {
      expandableRange: {
        behaviorClass: ExpandableRange
      }
    }

    className: () ->
      "evaluation-collection evaluation-collection-#{@model.get('evaluator_role').toLowerCase()}"

    initialize: (options) ->
      @collection = @model.get('evaluations')

    serializeData: () ->
      {
        title: "#{@model.get('evaluator_role')} Evaluations"
        percentage: @model.averageScore()
        range_class: 'range-expandable'
      }
