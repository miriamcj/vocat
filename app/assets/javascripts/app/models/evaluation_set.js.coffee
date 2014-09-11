define ['backbone'], (Backbone) ->

  class EvaluationSetModel extends Backbone.Model

    averageScore: () ->
      numbers = @get('evaluations').pluck('total_percentage')
      Math.round(_.reduce(numbers, (memo, num) ->
        memo + num
      , 0) / numbers.length)
      0

    toJSON: () ->
      attributes = _.clone(this.attributes);
      attributes.averageScore = @averageScore()
      console.log attributes,'attributes'
      attributes
