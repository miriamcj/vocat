define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/evaluations_layout')
  EvaluationCollection = require('collections/evaluation_collection')
  CollectionProxy = require('collections/collection_proxy')
  TheirEvaluations = require('views/submission/evaluations/their_evaluations')
  MyEvaluations = require('views/submission/evaluations/my_evaluations')

  Rubric = require('models/rubric')

  class EvaluationsLayout extends Marionette.LayoutView

    template: template

    regions: {
      theirEvaluations: '[data-region="their-evaluations"]'
      myEvaluations: '[data-region="my-evaluations"]'
    }

#    detailVisible: false
#
#    getChildView: (item) ->
#      EvaluationGroup
#
#    childViewOptions: () ->
#      {
#        vent: @
#        rubric: @rubric
#        label: @options.label
#      }
#
#    childViewContainer: '[data-behavior="scores-container"]'
#
#    ui: {
#      toggleDetailOn: '.js-toggle-detail-on'
#      toggleDetailOff: '.js-toggle-detail-off'
#    }
#
#    triggers: {
#      'click [data-behavior="toggle-detail"]': 'detail:toggle'
#    }


    # @model is a submission model.
    initialize: (options) ->
      @rubric = new Rubric(options.project.get('rubric'))
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')
      @evaluations = new EvaluationCollection(@model.get('evaluations'), {courseId: @courseId})

    showBabies: () ->
#      theirEvaluationsProxied = new CollectionProxy(@evaluations)
#      theirEvaluationsProxied.where (model) -> model.get('current_user_is_owner') == false
#      myEvaluationsProxied = new CollectionProxy(@evaluations)
#      myEvaluationsProxied.where (model) -> model.get('current_user_is_owner') == true

      @theirEvaluations.show(new TheirEvaluations({evaluations: @evaluations}))
      @myEvaluations.show(new MyEvaluations({evaluations: @evaluations}))

    onRender: () ->
      @showBabies()

#      @collection = new Backbone.Collection
#      evalTypes = _.uniq(@evaluations.pluck('evaluator_role'))
#      _.each(evalTypes, (evalType, index) =>
#        proxy = new CollectionProxy(@evaluations)
#        proxy.where((model) -> model.get('evaluator_role') == evalType)
#        set = new EvaluationSetModel({evaluations: proxy})
#        @collection.add(set)
#      )
#
#      myEvaluation = new CollectionProxy(@evaluations)
#      myEvaluation.where((model) -> model.get('current_user_is_owner' == true))
