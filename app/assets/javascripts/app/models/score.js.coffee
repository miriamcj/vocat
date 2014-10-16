define ['backbone'], (Backbone) ->

  class ScoreModel extends Backbone.Model

    getTicks: () ->
      [1,2,3,4,5,6]

    getTickWidth: () ->
      100 / @getTicks().length

    toJSON: () ->
      json = super()
      json.ticks = @getTicks()
      json.tickWidth = @getTickWidth()
      json