define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/their_evaluations_child')

  class TheirEvaluationsChild extends Marionette.ItemView

    template: template