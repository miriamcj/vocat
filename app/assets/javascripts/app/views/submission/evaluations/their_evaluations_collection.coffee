define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/their_evaluations_collection')
  ChildView = require('views/submission/evaluations/their_evaluations_child')

  class TheirEvaluationsCollection extends Marionette.CompositeView

    template: template
    className: 'evaluation-collection'
    tagName: 'li'
    className: () ->
      "evaluation-collection evaluation-collection-#{@model.get('evaluator_role').toLowerCase()}"

    childView: ChildView
    childViewContainer: '[data-behavior="child-container"]'

    initialize: (options) ->
      @collection = @model.get('evaluations')
