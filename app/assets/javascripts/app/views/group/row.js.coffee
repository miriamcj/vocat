define ['marionette', 'views/group/cell'], (Marionette, ItemView) ->

  class Row extends Marionette.CollectionView

    tagName: 'tr'
    className: 'matrix--row'

    childView: ItemView

    childViewOptions: () ->
      {
        vent: @vent
        creator: @model
      }

    initialize: (options) ->
      @vent = options.vent

    onAddChild: () ->
      @vent.trigger('recalculate')

    onRemoveChild: () ->
      @vent.trigger('recalculate')
