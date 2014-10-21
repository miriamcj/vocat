define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/my_evaluations_create')

  class MyEvaluationsCreate extends Marionette.ItemView

    template: template

    triggers:
      'click [data-behavior="create-evaluation"]': 'evaluation:new'

    onEvaluationNew: () ->
      @vent.triggerMethod('evaluation:new')

    initialize: (options) ->
      @vent = options.vent
