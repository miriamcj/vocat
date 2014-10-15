define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/my_evaluations')

  class MyEvaluations extends Marionette.ItemView

    template: template
    tagName: 'ul'
    className: 'evaluation-collections evaluation-editable'

    initialize: (options) ->
      @model = @collection.findWhere({current_user_is_evaluator: true})
      console.log @model.attributes,'attr'
#      @collection = options.collection
#      console.log options,'opt'
#      console.log @collection,'@collection'
