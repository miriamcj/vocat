define ['marionette', 'views/group/row_item'], (Marionette, ItemView) ->

  class RowsView extends Marionette.CollectionView

    itemView: ItemView

    itemViewOptions: () ->
      {
      vent: @vent
      collection: @collections.group
      }

    initialize: (options) ->
      @collections = options.collections
      @vent = options.vent
