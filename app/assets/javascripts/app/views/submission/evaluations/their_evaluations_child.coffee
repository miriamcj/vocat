define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/their_evaluations_child')
  ExpandableRange = require('behaviors/expandable_range')

  class TheirEvaluationsChild extends Marionette.ItemView

    tagName: 'li'
    className: 'evaluation-single'
    template: template
    childrenVisible: false;

    triggers: {
    }

    events: {
      'mouseenter @ui.placardTrigger': 'showPlacard'
      'mouseleave @ui.placardTrigger': 'hidePlacard'
    }

    ui: {
      'placard': '[data-behavior="range-placard"]'
      'placardTrigger': '[data-behavior="placard-trigger"]'
    }

    showPlacard: (e) ->
      e.preventDefault()
      e.stopPropagation()
      $el = $(e.target)
      $el.find('[data-behavior="range-placard"]').fadeIn()

    hidePlacard: (e) ->
      e.preventDefault()
      e.stopPropagation()
      @ui.placard.hide()

    behaviors: {
      expandableRange: {
        behaviorClass: ExpandableRange
      }
    }

    setupEvents: () ->
      @listenTo(@, 'show:placard', (e) =>
        @onShowPlacard(e)
      )

    initialize: (options) ->
      @rubric = options.rubric
      @setupEvents()

    serializeData: () ->
      sd ={
        title: @model.get('evaluator_name')
        percentage: Math.round(@model.get('total_percentage'))
        score_details: @model.scoreDetailsWithRubricDescriptions(@rubric)
      }
      sd
