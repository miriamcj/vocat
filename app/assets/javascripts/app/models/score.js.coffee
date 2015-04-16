define ['backbone'], (Backbone) ->
  class ScoreModel extends Backbone.Model

    getTicks: () ->
      h = parseInt(@.get('high'))
      l = parseInt(@.get('low'))
      l = 0
      possible = h - l
      if possible < 0
        tickCount = 1
      if possible < 10
        tickCount = possible
      else
        factors = []
        i = 10
        until i <= 3
          m = possible % i
          factors.push i if m == 0 && (possible / i < 10)
          i--
        tickCount = _.max(factors)
      _.range(tickCount)

    getTickWidth: () ->
      100 / @getTicks().length

    initialize: () ->

    toJSON: () ->
      json = super()
      json.ticks = @getTicks()
      json.tickWidth = @getTickWidth()
      json
