define ['marionette', 'views/rubric/row_item'], (Marionette, ItemView) ->

  class RowsView extends Marionette.CollectionView

    itemView: ItemView

    itemViewOptions: () ->
      {
      vent: @vent
      cells: @cells
      }

    initialize: (options) ->
      @vent = options.vent
      @cells = options.cells
