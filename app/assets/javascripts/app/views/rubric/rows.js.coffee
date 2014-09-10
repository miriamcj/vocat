define ['marionette', 'views/rubric/row_item'], (Marionette, ItemView) ->

  class RowsView extends Marionette.CollectionView

    childView: ItemView

    childViewOptions: () ->
      {
      vent: @vent
      cells: @cells
      }

    initialize: (options) ->
      @vent = options.vent
      @cells = options.cells
