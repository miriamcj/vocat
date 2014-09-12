define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/their_evaluations_child')

  class TheirEvaluationsChild extends Marionette.ItemView

    tagName: 'li'
    className: 'evaluation-single'
    template: template

    initialize: (options) ->
      console.log @model