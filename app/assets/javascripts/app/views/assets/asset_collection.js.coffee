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

    ui: {
      collectionContainer: '[data-behavior="collection-container"]'
    }

    triggers: {
      'click [data-behavior="do-render"]': 'forceRender'
    }

    emptyView: EmptyView

    emptyViewOptions: () ->
      {
        model: @project
        abilities: @abilities
        vent: @ventgit status

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
      @project = options.project
      @setupListeners()

    # TODO: Lots of overlap between this and the sortable table behavior. The
    # behavior should be improved and abstracted so that it can be used in this
    # class as well.
    updateSort: (model, position) ->
      if @collection.indexOf(model) != position
        model.set('listing_order_position', position)
        container = @$el.find(@childViewContainer)
        view = @children.findByModel(model)
        view.$el.detach()
        if position == 0
          container.prepend(view.$el)
        else
          container.children().eq(position).before(view.$el)
        model.save({})

    onAddChild: () ->
      @$el.sortable({
        containment: @ui.collectionContainer
        revert: true
        handle: '[data-behavior="move"]'
        items: '[data-behavior="sortable-item"]'
        cursor: "move"
        revert: 175
        stop: (event, ui) ->
          ui.item.trigger('asset:dropped', ui.item.index())
      })
