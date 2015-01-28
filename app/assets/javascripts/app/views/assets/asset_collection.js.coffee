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
        abilities: @abilities
      }

    template: template
    childViewContainer: '[data-behavior="collection-container"]'
    emptyView: EmptyView

    ui: {
      collectionContainer: '[data-behavior="collection-container"]'
    }

    triggers: {
      'click [data-behavior="do-render"]': 'forceRender'
    }

    onForceRender: () ->
      @render()

    setupListeners: () ->
      @listenTo(@, 'childview:update:sort', (rowView, args) ->
        @updateSort(args[0], args[1])
      )

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
      @abilities = options.abilities
      @setupListeners()

    # TODO: Lots of overlap between this and the sortable table behavior. The
    # behavior should be improved and abstracted so that it can be used in this
    # class as well.
    updateSort: (model, position) ->
      if @collection.indexOf(model) != position
        model.set('listing_order_position', position)
        @collection.remove(model, {silent: true})
        view = @children.findByModel(model)
        view.destroy()
        @collection.add(model, {at: position})
        model.save({}, {success: () =>
          model.fetch()
        })

    onAddChild: () ->
      @$el.sortable({
        containment: @ui.collectionContainer
        revert: true
#        helper: 'clone'
        handle: '[data-behavior="move"]'
        items: '[data-behavior="sortable-item"]'
        cursor: "move"
        revert: 175
        stop: (event, ui) ->
          ui.item.trigger('asset:dropped', ui.item.index())
      })
