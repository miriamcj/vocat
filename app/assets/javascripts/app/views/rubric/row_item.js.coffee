define ['marionette', 'hbs!templates/rubric/rows_item', 'collections/collection_proxy', 'views/rubric/cell'], (Marionette, template, CollectionProxy, CellView) ->

  class RowsItem extends Marionette.CollectionView

    template: template

    tagName: 'ul'
    className: 'matrix--row'

    childView: CellView

    childViewOptions: {
      vent: @vent
    }

    initialize: (options) ->
      @vent = options.vent
      proxy = CollectionProxy(options.cells)
      proxy.where({range: @model.id})
      @collection = proxy
