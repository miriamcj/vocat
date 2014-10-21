define [
  'marionette', 'hbs!templates/submission/my_evaluation', 'collections/evaluation_collection', 'models/evaluation', 'models/rubric', 'views/flash/flash_messages',
  'views/submission/evaluation_item', 'views/submission/evaluation_item_edit', 'views/submission/my_evaluation_empty', 'views/modal/modal_confirm'
], (
  Marionette, template, EvaluationCollection, Evaluation, Rubric, FlashMessagesView, EvaluationItem, EvaluationItemEdit, MyEvaluationEmpty, ModalConfirmView
) ->
  class MyEvaluationDetail extends Marionette.CompositeView

    template: template
    detailVisible: false
    childView: EvaluationItemEdit
    emptyView: MyEvaluationEmpty
    childViewContainer: '[data-behavior="scores-container"]'

    ui: {
      toggleDetailOn: '.js-toggle-detail-on'
      toggleDetailOff: '.js-toggle-detail-off'
      flashContainer: '[data-container="flash"]'
      publishButton: '[data-behavior="evaluation-publish"]'
      unpublishButton: '[data-behavior="evaluation-unpublish"]'
      destroyButton: '[data-behavior="evaluation-destroy"]'
      saveButton: '[data-behavior="evaluation-save"]'
    }

    events: {
      'click [data-behavior="evaluation-destroy"]': 'onEvaluationDestroy'
    }

    triggers: {
      'click ui.destroyButton': 'evaluation:destroy'
      'click @ui.publishButton': 'evaluation:publish'
      'click @ui.unpublishButton': 'evaluation:unpublish'
      'click @ui.saveButton': 'evaluation:save'
      'click [data-behavior="toggle-detail"]': 'detail:toggle'
    }

    onEvaluationPublish: () ->
      @model.set('published',true)

    onEvaluationDestroy: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Deleted evaluations cannot be recovered. Please confirm that you would like to delete your evaluation.',
        confirmEvent: 'confirm:destroy',
        dismissEvent: 'dismiss:destroy'
      }))

    onEvaluationUnpublish: () ->
      @model.set('published',true)

    onRender: () ->
      @ui.flashContainer.append(@flash.$el)
      @flash.render()

    onBeforeClose: () ->
      @flash.destroy()
      # Do child view garbage collection here

    childViewOptions: () ->
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
          @vent.triggerMethod('evaluation:created')
          #TODO: Move these model changes into the model itself as a method
          @model.set('current_user_has_evaluated',true)
          @model.set('current_user_percentage',0)
          @model.set('current_user_evaluation_published',false)
          @trigger('error:add', {level: 'notice', msg: 'Evaluation successfully created'})
        , error: () =>
          @trigger('error:add', {level: 'error', msg: 'Unable to create evaluation. Perhaps you do not have permission to evaluate this submission.'})
      })

    onConfirmDestroy: () ->
      evaluation = @collection.at(0)
      evaluation.destroy({
        success: () =>
          #TODO: Move these model changes into the model itself as a method
          @model.set('current_user_has_evaluated',false)
          @model.set('current_user_percentage',null)
          @model.set('current_user_evaluation_published',null)
          @trigger('error:add', {level: 'notice', msg: 'Evaluation successfully deleted'})
      })
      @render()

    onEvaluationDestroy: (event) ->
      event.preventDefault()
      event.stopPropagation()
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Deleted evaluations cannot be recovered. Please confirm that you would like to delete your evaluation.',
        confirmEvent: 'confirm:destroy',
        dismissEvent: 'dismiss:destroy'
      }))

    serializeData: () ->
      {
        evaluationExists: @collection.length > 0
      }

    initialize: (options) ->
      console.log @model.attributes, 'model'
      @rubric = new Rubric(options.project.get('rubric'))
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')
      @flash = new FlashMessagesView({vent: @, clearOnAdd: true})

