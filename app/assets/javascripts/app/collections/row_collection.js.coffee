define ['backbone', 'models/row'], (Backbone, RowModel) ->
  class RowCollection extends Backbone.Collection
    model: RowModel
