define ['backbone', 'models/cell'], (Backbone, CellModel) ->
  class CellCollection extends Backbone.Collection
    model: CellModel

    comparator: (range) ->
      range.get('low')