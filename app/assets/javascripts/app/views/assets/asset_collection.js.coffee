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
        vent: @vent
      }

    onForceRender: () ->
      @render()

    setupListeners: () ->
      @listenTo(@collection, 'change:listing_order', (e) ->
        @render()
      )

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
      @abilities = options.abilities
      @project = options.project
      @setupListeners()
