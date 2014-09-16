define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/their_evaluations_collection')
  ChildView = require('views/submission/evaluations/their_evaluations_child')

  class TheirEvaluationsCollection extends Marionette.CompositeView

    template: template
    className: 'evaluation-collection'
    tagName: 'li'
    childView: ChildView
    childrenVisible: false
    childViewContainer: '[data-behavior="collection-child-container"]'

    triggers: {
      'click @ui.toggleChild': 'toggle:child'
    }

    ui: {
      toggleChild: '[data-behavior="toggle-collection-children"]'
      childContainer: '[data-behavior="collection-child-container"]'
    }

    onToggleChild: () ->
      if @childrenVisible
        @ui.childContainer.slideUp(250)
      else
        @ui.childContainer.slideDown(250)
      @childrenVisible = !@childrenVisible

    className: () ->
      "evaluation-collection evaluation-collection-#{@model.get('evaluator_role').toLowerCase()}"

    initialize: (options) ->
      @collection = @model.get('evaluations')

    onRender: () ->
      @listenTo(@$el,'click', () ->
        console.log 'clicked'
      )

    onShow: () ->
      if @childrenVisible == false
        @ui.childContainer.hide()

    serializeData: () ->
      {
        title: "#{@model.get('evaluator_role')} Evaluations"
        percentage: @model.averageScore()
      }
