define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/asset_collection')
  ChildView = require('views/assets/asset_collection_child')
  EmptyView = require('views/assets/asset_collection_empty')

  class AssetCollection extends Marionette.CompositeView

    childView: ChildView

    childViewOptions: () ->
      {
        vent: @vent
      }

    template: template
    childViewContainer: '[data-behavior="collection-container"]'
    emptyView: EmptyView

    triggers: {
      'click [data-behavior="do-render"]': 'forceRender'
    }

    onForceRender: () ->
      @render()

    setupListeners: () ->
      @listenTo(@, 'all', (e) ->
        console.log e,'event'
      )
      @listenTo(@, 'childview:update:sort', (rowView, args) ->
        @updateSort(args[0], args[1])
      )

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
      @setupListeners()

    # TODO: Lots of overlap between this and the sortable table behavior. The
    # behavior should be improved and abstracted so that it can be used in this
    # class as well.
    updateSort: (model, position) ->
      console.log model, position
      adjustedPosition = position
      @collection.remove(model)
      model.set('listing_order_position', adjustedPosition)
      @collection.add(model, {at: position})
      model.save()

    onAddChild: ()->
      @$el.sortable({
        revert: true
        handle: '[data-behavior="move"]'
        items: '[data-behavior="sortable-item"]'
        cursor: "move"
        revert: 175
        stop: (event, ui) ->
          ui.item.trigger('drop', ui.item.index())
      })
