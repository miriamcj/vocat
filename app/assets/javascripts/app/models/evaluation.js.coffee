define ['backbone'], (Backbone) ->
  class EvaluationModel extends Backbone.Model

    paramRoot: 'evaluation'

    urlRoot: "/api/v1/evaluation"
