define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/evaluations_layout')
  EvaluationCollection = require('collections/evaluation_collection')
  Evaluation = require('models/evaluation')
  CollectionProxy = require('collections/collection_proxy')
  TheirEvaluations = require('views/submission/evaluations/their_evaluations')
  TheirEvaluationsEmpty = require('views/submission/evaluations/their_evaluations_empty')
  MyEvaluations = require('views/submission/evaluations/my_evaluations')
  MyEvaluationsCreate = require('views/submission/evaluations/my_evaluations_create')
  SaveNotifyView = require('views/submission/evaluations/save_notify')
  RubricModel = require('models/rubric')

  class EvaluationsLayout extends Marionette.LayoutView

    template: template

    regions: {
      theirEvaluations: '[data-region="their-evaluations"]'
      myEvaluations: '[data-region="my-evaluations"]'
    }

    ui: {
      body: '[data-behavior="body"]'
    }

    onEvaluationDestroy: () ->
      myEvaluation = @evaluations.findWhere({current_user_is_evaluator: true})
      myEvaluation.destroy({wait: true, success: () =>
        @showMyEvaluations()
        Vocat.vent.trigger('notification:empty')
      })

    onEvaluationDirty: () ->
      saveNotifyView = new SaveNotifyView({model: @myEvaluationModel(), vent: @})
      Vocat.vent.trigger('notification:show', saveNotifyView)

    onEvaluationSave: () ->
      m = @myEvaluationModel()
      if m?
        Vocat.vent.trigger('notification:empty')
        m.save({}, {
          success: () =>
            @trigger('evaluation:save:success')
            @model.fetch()
          error: (response) =>
            Vocat.vent.trigger('error:add', {level: 'error', msg: 'Unable to save evaluation'})
        })
        if m.validationError
          Vocat.vent.trigger('error:add', {level: 'error', msg: m.validationError})

    onEvaluationRevert: () ->
      m = @myEvaluationModel()
      if m?
        m.revert()

    # This generally is triggered by the child empty view
    onEvaluationNew: () ->
      evaluation = new Evaluation({submission_id: @model.id})
      evaluation.save({}, {
        success: () =>
          @evaluations.add(evaluation)
          @vent.triggerMethod('evaluation:created')
          @model.unsetMyEvaluation()
          @showMyEvaluations(true)
        , error: () =>
          Vocat.vent.trigger('error:add', {level: 'error', msg: 'Unable to create evaluation. Perhaps you do not have permission to evaluate this submission.'})
          @showMyEvaluations()
      })

    # @model is a submission model.
    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')
      @rubric = new RubricModel(@model.get('project').rubric)

      @evaluations = new EvaluationCollection(@model.get('evaluations'), {courseId: @courseId})

    myEvaluationModel: () ->
      @evaluations.findWhere({current_user_is_evaluator: true})

    showMyEvaluations: (openOnShow = false) ->
      if @myEvaluationModel()?
        @myEvaluations.show(new MyEvaluations({model: @myEvaluationModel(), rubric: @rubric, vent: @}))
        if openOnShow == true
          @myEvaluations.currentView.triggerMethod('toggle:child')
      else
        @myEvaluations.show(new MyEvaluationsCreate({evaluations: @evaluations, rubric: @rubric, vent: @}))

    showTheirEvaluations: () ->
      if (@myEvaluationModel() && @evaluations.length == 1) || @evaluations.length == 0
        @theirEvaluations.$el.addClass('evaluation-collection-empty')
        if @model.get('abilities').can_evaluate == false
          @theirEvaluations.show(new TheirEvaluationsEmpty())
      else
        @theirEvaluations.$el.removeClass('evaluation-collection-empty')
        @theirEvaluations.show(new TheirEvaluations({evaluations: @evaluations, rubric: @rubric}))

    onRender: () ->
      @showTheirEvaluations()
      if @model.get('abilities').can_evaluate == true
        @showMyEvaluations()
