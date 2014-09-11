define ['marionette', 'hbs!templates/submission/my_evaluation_empty'], (Marionette, template) ->

  class MyEvaluationEmpty extends Marionette.ItemView

    template: template

    triggers:
      'click [data-behavior="create-evaluation"]': 'evaluation:new'

    onEvaluationNew: () ->
      @vent.triggerMethod('evaluation:new')

    initialize: (options) ->
      @vent = options.vent
