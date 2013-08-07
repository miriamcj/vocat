define ['marionette', 'views/rubric/fields_item'], (Marionette, ItemView) ->

  class FieldsView extends Marionette.CollectionView

    itemView: ItemView
    tagName: 'ul'
    className: 'matrix--column-header--list'
    itemViewOptions: () ->
      {
      vent: @vent
      }

    initialize: (options) ->
      @vent = options.vent

