define ['backbone'], (Backbone) ->
  class EvaluationModel extends Backbone.Model

    paramRoot: 'evaluation'

    urlRoot: "/api/v1/evaluations"


    initialize: () ->
      @on('change:scores', () =>
        @updateCalculatedScoreFields()
      )

    updateCalculatedScoreFields: () ->
      total = 0
      _.each(@.get('scores'), (score) =>
        total = total + parseInt(score)
      )
      console.log total, 'total'
      per = parseFloat(total / parseInt(@get('points_possible'))) * 100
      @set('total_percentage', per)
      @set('total_percentage_rounded', per.toFixed(1))
