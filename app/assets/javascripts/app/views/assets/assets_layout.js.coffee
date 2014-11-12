define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/assets_layout')
  AssetCollectionView = require('views/assets/asset_collection')
  NewAssetView = require('views/assets/new_asset')

  class AssetsLayout extends Marionette.LayoutView

    template: template

    ui: {
      newAssetContainer: '[data-behavior="new-asset-container"]'
      manageLink: '[data-behavior="manage-link"]'
      stopManagingLink: '[data-behavior="stop-manage-link"]'
    }

    collectionEvents: {
      'add': 'ensureVisibleCollectionView'
      'remove': 'hideEmptyCollectionViewIfNewIsVisible'
    }

    triggers: {
      'click @ui.stopManagingLink': 'hide:new'
      'click @ui.manageLink': 'show:new'
    }

    regions: {
      assets: '[data-region="asset-collection"]'
      newAsset: '[data-region="asset-new"]'
    }

    onShowNew: () ->
      @newAsset.show(new NewAssetView({collection: @collection, model: @model.project(), vent: @}))
      @hideEmptyCollectionViewIfNewIsVisible()
      @ui.manageLink.hide()
      @ui.stopManagingLink.show()
      @newAsset.$el.fadeIn(200)

    onHideNew: () ->
      @ui.manageLink.show()
      @ui.stopManagingLink.hide()
      @newAsset.$el.fadeOut(200, () =>
        @newAsset.empty()
        @ensureVisibleCollectionView()
      )

    hideEmptyCollectionViewIfNewIsVisible: () ->
      if @collection.length == 0 && @newAsset.currentView?
        @assets.empty()

    ensureVisibleCollectionView: () ->
      if !@assets.currentView?
        @assets.show(new AssetCollectionView({collection: @collection, vent: @}))
      unless @assets.$el.is(':visible')
        @newAsset.$el.fadeIn(200)

    onRender: () ->
      @ensureVisibleCollectionView()
      # TODO: Remove this
      # @onShowNew()

    setupListeners: () ->
      @listenTo(@, 'hide:new', () =>
        @onHideNew()
      )
      @listenTo(@, 'show:new', () =>
        @onShowNew()
      )

    # @model is a submission model.
    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
      @setupListeners()
