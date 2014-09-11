define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/their_evaluations_collection')

  class TheirEvaluationsCollection extends Marionette.CompositeView

    template: template

    initialize: (options) ->
      console.log @model.attributes
