define ['backbone', 'models/range'], (Backbone, RangeModel) ->

  class RangeCollection extends Backbone.Collection
    model: RangeModel

    comparator: (range) ->
      range.get('low')