define ['marionette', 'hbs!templates/rubric/rows_item', 'views/group/cell'], (Marionette, template, ItemView) ->

  class RowsItem extends Marionette.CollectionView

    tagName: 'ul'
    className: 'matrix--row'

    itemView: ItemView

    itemViewOptions: () ->
      {
        vent: @vent
      }

    initialize: (options) ->
      @vent = options.vent
