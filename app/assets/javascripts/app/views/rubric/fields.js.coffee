define ['marionette', 'views/rubric/fields_item'], (Marionette, ItemView) ->

  class FieldsView extends Marionette.CollectionView

    childView: ItemView
    tagName: 'ul'
    className: 'matrix--column-header--list'
    childViewOptions: () ->
      {
      vent: @vent
      }

    initialize: (options) ->
      @vent = options.vent

