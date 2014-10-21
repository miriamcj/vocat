define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/evaluations_layout')
  EvaluationCollection = require('collections/evaluation_collection')
  Evaluation = require('models/evaluation')
  CollectionProxy = require('collections/collection_proxy')
  TheirEvaluations = require('views/submission/evaluations/their_evaluations')
  MyEvaluations = require('views/submission/evaluations/my_evaluations')
  MyEvaluationsCreate = require('views/submission/evaluations/my_evaluations_create')
  SaveNotifyView = require('views/submission/evaluations/save_notify')

  Rubric = require('models/rubric')

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
      })

    onEvaluationDirty: () ->
      Vocat.vent.trigger('notification:show', new SaveNotifyView({model: @myEvaluationModel()}))

    # @model is a submission model.
    initialize: (options) ->
      @rubric = new Rubric(options.project.get('rubric'))
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')
      @evaluations = new EvaluationCollection(@model.get('evaluations'), {courseId: @courseId})

    myEvaluationModel: () ->
      @evaluations.findWhere({current_user_is_evaluator: true})

    showMyEvaluations: (openOnShow = false) ->
      if @myEvaluationModel()?
        @myEvaluations.show(new MyEvaluations({model: @myEvaluationModel(), vent: @}))
        if openOnShow == true
          @myEvaluations.currentView.triggerMethod('toggle:child')
      else
        @myEvaluations.show(new MyEvaluationsCreate({evaluations: @evaluations, vent: @}))

    showTheirEvaluations: () ->
      @theirEvaluations.show(new TheirEvaluations({evaluations: @evaluations}))

    onRender: () ->
      @showTheirEvaluations()
      @showMyEvaluations()

    # This generally is triggered by the child empty view
    onEvaluationNew: () ->
      evaluation = new Evaluation({submission_id: @model.id})
      evaluation.save({}, {
        success: () =>
          @evaluations.add(evaluation)
          @vent.triggerMethod('evaluation:created')
          @model.set('current_user_has_evaluated',true)
          @model.set('current_user_percentage',0)
          @model.set('current_user_evaluation_published',false)
          Vocat.vent.trigger('error:add', {level: 'notice', msg: 'Evaluation successfully created'})
          @showMyEvaluations(true)
        , error: () =>
          Vocat.vent.trigger('error:add', {level: 'error', msg: 'Unable to create evaluation. Perhaps you do not have permission to evaluate this submission.'})
          @showMyEvaluations()
      })
