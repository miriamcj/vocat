define [
  'marionette', 'hbs!templates/submission/my_evaluation', 'collections/evaluation_collection', 'models/evaluation', 'models/rubric', 'views/submission/evaluation_item', 'views/submission/evaluation_item_edit', 'views/submission/my_evaluation_empty'
], (
  Marionette, template, EvaluationCollection, Evaluation, Rubric, EvaluationItem, EvaluationItemEdit, MyEvaluationEmpty
) ->
  class MyEvaluationDetail extends Marionette.CompositeView

    template: template
    detailVisible: false
    itemView: EvaluationItemEdit
    emptyView: MyEvaluationEmpty
    itemViewContainer: '[data-behavior="scores-container"]'

    ui: {
      toggleDetailOn: '.js-toggle-detail-on'
      toggleDetailOff: '.js-toggle-detail-off'
    }

    triggers: {
      'click [data-behavior="toggle-detail"]': 'detail:toggle'
      'click [data-behavior="evaluation-destroy"]': 'evaluation:destroy'
    }

    itemViewOptions: () ->
      {
      errorVent: @vent
      vent: @
      rubric: @rubric
      }

    # This generally is triggered by the child empty view
    onEvaluationNew: () ->
      evaluation = new Evaluation({submission_id: @model.id})
      evaluation.save({}, {
        success: () =>
          @collection.add(evaluation)
          @vent.trigger('error:add', {level: 'notice', msg: 'Evaluation successfully created'})
        , error: () =>
          @vent.trigger('error:add', {level: 'error', msg: 'Unable to create evaluation. Perhaps you do not have permission to evaluate this submission.'})
      })

    onEvaluationDestroy: () ->
      evaluation = @collection.at(0)
      results = confirm('Deleted evaluations cannot be recovered. Please confirm that you would like to delete your evaluation.')
      if results == true
        evaluation.destroy({
          success: () =>
            @vent.trigger('error:add', {level: 'notice', msg: 'Evaluation successfully deleted'})
        })

    serializeData: () ->
      {
        evaluationExists: @collection.length > 0
      }

    initialize: (options) ->
      @rubric = new Rubric(options.project.get('rubric'))
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')

