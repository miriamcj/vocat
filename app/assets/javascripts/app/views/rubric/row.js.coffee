define ['marionette', 'collections/collection_proxy', 'views/rubric/cell'], (Marionette, CollectionProxy, CellView) ->

  class Row extends Marionette.CollectionView

    tagName: 'tr'

    childView: CellView

    childViewOptions: () ->
      {
        vent: @vent
        field: @model
        rubric: @rubric
      }

    initialize: (options) ->
      @rubric = options.rubric
      @vent = options.vent

      @listenTo(@rubric.get('ranges'), 'remove', (e) =>
        @render()
      )
