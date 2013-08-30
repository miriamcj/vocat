define ['marionette', 'views/course_map/row_item'], (Marionette, ItemView) ->

  class RowsView extends Marionette.CollectionView

    itemView: ItemView

    itemViewOptions: () ->
      {
      vent: @vent
      collection: @collections.project
      submissions: @collections.submission
      }

    initialize: (options) ->
      @collections = options.collections
      @vent = options.vent
