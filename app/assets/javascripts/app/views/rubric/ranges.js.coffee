define ['marionette', 'views/rubric/ranges_item'], (Marionette, ItemView) ->

  class RangesView extends Marionette.CollectionView

    itemView: ItemView
    tagName: 'ul'
    itemViewOptions: () ->
      {
        vent: @vent
      }

    initialize: (options) ->
      @vent = options.vent