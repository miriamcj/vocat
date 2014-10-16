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

    # @model is a submission model.
    initialize: (options) ->
      @rubric = new Rubric(options.project.get('rubric'))
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')
      @evaluations = new EvaluationCollection(@model.get('evaluations'), {courseId: @courseId})

    showBabies: () ->
      @theirEvaluations.show(new TheirEvaluations({evaluations: @evaluations}))
      @myEvaluations.show(new MyEvaluations({evaluations: @evaluations}))

    onRender: () ->
      @showBabies()
