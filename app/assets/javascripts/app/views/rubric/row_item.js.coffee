define ['marionette', 'hbs!templates/rubric/rows_item', 'collections/cell_collection_proxy', 'views/rubric/cell'], (Marionette, template, CellCollectionProxy, CellView) ->

  class RowsItem extends Marionette.CollectionView

    template: template

    tagName: 'ul'
    className: 'matrix--row'

    itemView: CellView

    itemViewOptions: {
      vent: @vent
    }

    initialize: (options) ->
      @vent = options.vent
      proxy = CellCollectionProxy(options.cells)
      proxy.where({range: @model.id})
      @collection = proxy
