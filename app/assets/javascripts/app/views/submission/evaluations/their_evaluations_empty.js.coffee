define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/their_evaluations_empty')

  class TheirEvaluationsEmpty extends Marionette.ItemView

    template: template
