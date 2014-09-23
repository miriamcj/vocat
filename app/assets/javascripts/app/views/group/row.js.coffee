define ['marionette', 'hbs!templates/rubric/rows_item', 'views/group/cell'], (Marionette, template, ItemView) ->

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
