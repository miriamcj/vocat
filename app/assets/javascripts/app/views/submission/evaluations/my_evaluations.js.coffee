define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/my_evaluations')

  class MyEvaluations extends Marionette.CompositeView

    template: template