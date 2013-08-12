define [
  'marionette', 'hbs!templates/submission/my_evaluation', 'collections/evaluation_collection', 'models/evaluation', 'models/rubric', 'views/flash/flash_messages', 'views/submission/evaluation_item', 'views/submission/evaluation_item_edit', 'views/submission/my_evaluation_empty'
], (
  Marionette, template, EvaluationCollection, Evaluation, Rubric, FlashMessagesView, EvaluationItem, EvaluationItemEdit, MyEvaluationEmpty
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
      flashContainer: '[data-container="flash"]'
    }

    triggers: {
      'click [data-behavior="toggle-detail"]': 'detail:toggle'
      'click [data-behavior="evaluation-destroy"]': 'evaluation:destroy'
    }

    onRender: () ->
      @ui.flashContainer.append(@flash.$el)
      @flash.render()

    onBeforeClose: () ->
      @flash.close()
      # Do child view garbage collection here

    itemViewOptions: () ->
      {
      vent: @
      rubric: @rubric
      }

    onMyEvaluationUpdated: (data) ->
      if data.percentage?
        @model.set('current_user_evaluation', data.model.toJSON())
        @model.set('current_user_percentage', data.percentage)

    onMyEvaluationPublished: () ->
      @model.set('current_user_evaluation_published',true)

    onMyEvaluationUnpublished: () ->
      @model.set('current_user_evaluation_published',false)

    # This generally is triggered by the child empty view
    onEvaluationNew: () ->
      evaluation = new Evaluation({submission_id: @model.id})
      evaluation.save({}, {
        success: () =>
          @collection.add(evaluation)
          @model.set('current_user_has_evaluated',true)
          @model.set('current_user_percentage',0)
          @model.set('current_user_evaluation_published',false)
          @trigger('error:add', {level: 'notice', msg: 'Evaluation successfully created'})
        , error: () =>
          @trigger('error:add', {level: 'error', msg: 'Unable to create evaluation. Perhaps you do not have permission to evaluate this submission.'})
          @render()
      })

    onEvaluationDestroy: () ->
      evaluation = @collection.at(0)
      results = confirm('Deleted evaluations cannot be recovered. Please confirm that you would like to delete your evaluation.')
      if results == true
        evaluation.destroy({
          success: () =>
            @model.set('current_user_has_evaluated',false)
            @model.set('current_user_percentage',null)
            @model.set('current_user_evaluation_published',null)
            @trigger('error:add', {level: 'notice', msg: 'Evaluation successfully deleted'})
        })
        @render()

    serializeData: () ->
      {
        evaluationExists: @collection.length > 0
      }

    initialize: (options) ->
      @rubric = new Rubric(options.project.get('rubric'))
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')
      @flash = new FlashMessagesView({vent: @, clearOnAdd: true})

