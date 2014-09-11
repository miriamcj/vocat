define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/evaluation_empty')

  class EvaluationEmpty extends Marionette.ItemView

    template: template

    initialize: (options) ->
      @vent = options.vent

    serializeData: () ->
      {
      label: @options.label.toLowerCase()
      }