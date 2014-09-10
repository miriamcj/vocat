define ['marionette', 'views/rubric/ranges_item'], (Marionette, ItemView) ->

  class RangesView extends Marionette.CollectionView

    childView: ItemView
    tagName: 'ul'
    childViewOptions: () ->
      {
        vent: @vent
      }

    initialize: (options) ->
      @vent = options.vent