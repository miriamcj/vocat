define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/their_evaluations_child')

  class TheirEvaluationsChild extends Marionette.ItemView

    tagName: 'li'
    className: 'evaluation-single'
    template: template

    triggers: {
      'click @ui.toggleChild': 'toggle:child'
    }

    ui: {
      toggleChild: '[data-behavior="toggle-evaluation-detail"]'
      childContainer: '[data-behavior="detail-child-container"]'
    }

    onToggleChild: () ->
      @ui.childContainer.toggleClass('evaluations-hidden')


    initialize: (options) ->

    serializeData: () ->
      sd ={
        title: @model.get('evaluator_name')
        percentage: Math.round(@model.get('total_percentage'))
        score: @model.get('score')
      }
      console.log sd
      sd
