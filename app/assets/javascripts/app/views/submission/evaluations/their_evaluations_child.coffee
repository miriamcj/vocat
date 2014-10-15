define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/their_evaluations_child')
  ExpandableRange = require('behaviors/expandable_range')

  class TheirEvaluationsChild extends Marionette.ItemView

    tagName: 'li'
    className: 'evaluation-single'
    template: template
    childrenVisible: false;

    behaviors: {
      expandableRange: {
        behaviorClass: ExpandableRange
      }
    }

    initialize: (options) ->

    serializeData: () ->
      sd ={
        title: @model.get('evaluator_name')
        percentage: Math.round(@model.get('total_percentage'))
        score_details: @model.get('score_details')
      }
      sd
