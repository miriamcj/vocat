define ['backbone', 'models/score'], (Backbone, ScoreModel) ->

  class ScoreCollection extends Backbone.Collection
    model: ScoreModel
