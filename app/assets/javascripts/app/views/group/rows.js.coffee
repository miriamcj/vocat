define ['marionette', 'views/group/row_item'], (Marionette, ItemView) ->

  class RowsView extends Marionette.CollectionView

    childView: ItemView

    childViewOptions: () ->
      {
      vent: @vent
      collection: @collections.group
      }

    initialize: (options) ->
      @collections = options.collections
      @vent = options.vent
