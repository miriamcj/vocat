define [
  'marionette', 'hbs!templates/submission/evaluation', 'collections/evaluation_collection', 'models/rubric', 'views/submission/evaluation_item', 'views/submission/evaluation_item_edit', 'views/submission/evaluation_empty'
], (
  Marionette, template, EvaluationCollection, Rubric, EvaluationItem, EvaluationItemEdit, EvaluationEmpty
) ->
  class EvaluationDetailScore extends Marionette.CompositeView

    template: template

    detailVisible: false

    childView: EvaluationItem

    getChildView: (item) ->
      if item.get('current_user_is_owner') == true
        EvaluationItemEdit
      else
        EvaluationItem

    childViewOptions: () ->
      {
        vent: @
        rubric: @rubric
        label: @options.label
      }

    emptyView: EvaluationEmpty
    childViewContainer: '[data-behavior="scores-container"]'

    ui: {
      toggleDetailOn: '.js-toggle-detail-on'
      toggleDetailOff: '.js-toggle-detail-off'
    }

    triggers: {
      'click [data-behavior="toggle-detail"]': 'detail:toggle'
    }

    serializeData: () ->
      {
      evaluationExists: @collection.length > 0
      label: @options.label
      }

    initialize: (options) ->
      @rubric = new Rubric(options.project.get('rubric'))
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')

    onRender: () ->
#      if @collection.length == 0 then @$el.hide()