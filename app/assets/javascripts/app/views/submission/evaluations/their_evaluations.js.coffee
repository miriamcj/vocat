define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/their_evaluations')
  TheirEvaluationsCollection = require('views/submission/evaluations/their_evaluations_collection')
  CollectionProxy = require('collections/collection_proxy')
  EvaluationSetModel = require('models/evaluation_set')

  class TheirEvaluations extends Marionette.CompositeView

    template: template
    tagName: 'ul'
    className: 'evaluation-collections'
    childView: TheirEvaluationsCollection

    initialize: (options) ->
      @evaluations= Marionette.getOption(@, 'evaluations')

      @collection = new Backbone.Collection
      evalTypes = _.uniq(@evaluations.pluck('evaluator_role'))
      _.each(evalTypes, (evalRole, index) =>
        proxy = new CollectionProxy(@evaluations)

        proxy.where((model) ->
          model.get('evaluator_role') == evalRole && model.get('current_user_is_owner') != true)
        set = new EvaluationSetModel({evaluations: proxy, evaluator_role: evalRole})
        @collection.add(set)
      )

