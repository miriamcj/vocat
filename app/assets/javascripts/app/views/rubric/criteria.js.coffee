define (require) ->
  template = require('hbs!templates/rubric/criteria')
  ItemView = require('views/rubric/criteria_item')


  class Criteria extends Marionette.CompositeView

    template: template
    className: 'criteria'
    childViewContainer: '[data-region="criteria-rows"]'
    childView: ItemView

    ui: {
      criteriaAdd: '.criteria-add-button',
      criteriaInstruction: '.criteria-instruction'
    }

    childViewOptions: () ->
      {
        collection: @collection
      }

    showCriteriaAdd: () ->
      if @collection.length > 3
        $(@ui.criteriaAdd).css('display', 'none')
      else
        $(@ui.criteriaAdd).css('display', 'inline-block')

    showCriteriaInstruction: () ->
      if @collection.length > 0
        $(@ui.criteriaInstruction).css('display', 'none')
      else
        $(@ui.criteriaInstruction).css('display', 'inline-block')

    onShow: () ->
      @showCriteriaAdd()
      @showCriteriaInstruction()

    initialize: (options) ->
      @listenTo(@, 'add:child destroy:child remove:child', () ->
        @showCriteriaAdd()
        @showCriteriaInstruction()
      )