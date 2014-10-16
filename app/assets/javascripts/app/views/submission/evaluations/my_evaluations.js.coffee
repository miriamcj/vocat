define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/my_evaluations')
  ScoreSlider = require('views/submission/evaluations/score_slider')

  class MyEvaluations extends Marionette.CompositeView

    template: template
    tagName: 'ul'
    className: 'evaluation-collections evaluation-editable'
    childViewContainer: '[data-behavior="child-container"]'
    childView: ScoreSlider

    initialize: (options) ->
      @model = options.evaluations.findWhere({current_user_is_evaluator: true})
      @collection = @model.getScoresCollection()

    onShow: () ->
