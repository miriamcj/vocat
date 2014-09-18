define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/their_evaluations_child')

  class TheirEvaluationsChild extends Marionette.ItemView

    tagName: 'li'
    className: 'evaluation-single'
    template: template
    childrenVisible: false;

    triggers: {
      'click @ui.toggleChild': 'toggle:child'
    }

    ui: {
      toggleChild: '[data-behavior="toggle-evaluation-detail"]'
      childContainer: '[data-behavior="detail-child-container"]'
    }

    onToggleChild: () ->
      if @ui.childContainer.length > 0
        if @childrenVisible
          @ui.childContainer.slideUp(250)
        else
          @ui.childContainer.slideDown(250)
      @childrenVisible = !@childrenVisible

    onShow: () ->
      if @childrenVisible == false
        @ui.childContainer.hide()

    initialize: (options) ->

    serializeData: () ->
      sd ={
        title: @model.get('evaluator_name')
        percentage: Math.round(@model.get('total_percentage'))
        score: @model.get('score')
      }
      sd
