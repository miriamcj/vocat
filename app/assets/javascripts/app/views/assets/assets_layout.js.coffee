define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/assets_layout')
  AssetCollectionView = require('views/assets/asset_collection')
  NewAssetView = require('views/assets/new_asset')
  NewAssetFooterView = require('views/assets/new_asset_footer')

  class AssetsLayout extends Marionette.LayoutView

    template: template
    manageVisible: false

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
      newAssetFooter: '[data-region="asset-new-footer"]'
    }

    preventManageClose: () ->
      if @manageVisible == true
        @ui.stopManagingLink.css(display: 'none')

    allowManageClose: () ->
      if @manageVisible == true
        @ui.stopManagingLink.css(display: 'inline-block')

    onShowNew: () ->
      abilities = @model.get('abilities')
      if abilities.can_attach
        @manageVisible = true
        @newAsset.show(new NewAssetView({collection: @collection, model: @model.project(), vent: @}))
        @newAssetFooter.show(new NewAssetFooterView({vent: @}))
        @hideEmptyCollectionViewIfNewIsVisible()
        @ui.manageLink.css(display: 'none')
        @ui.stopManagingLink.css(display: 'inline-block')
        @newAsset.$el.fadeIn(200)
        if @collection.length > 0
          @newAssetFooter.$el.fadeIn(200)
        else
          @newAssetFooter.$el.hide()

    onHideNew: () ->
      @manageVisible = false
      @ui.manageLink.show()
      @ui.manageLink.css(display: 'inline-block')
      @ui.stopManagingLink.css(display: 'none')
      @newAssetFooter.$el.fadeOut(200)
      @newAsset.$el.fadeOut(200, () =>
        @newAsset.empty()
        @ensureVisibleCollectionView()
      )

    hideEmptyCollectionViewIfNewIsVisible: () ->
      if @collection.length == 0 && @newAsset.currentView?
        @assets.empty()

    ensureVisibleCollectionView: () ->
      if !@assets.currentView?
        @assets.show(new AssetCollectionView({collection: @collection, vent: @, project: @model.project(), abilities: @model.get('abilities')}))
      unless @assets.$el.is(':visible')
        @newAsset.$el.fadeIn(200)

    onRender: () ->
      @ui.stopManagingLink.css(display: 'none')
      @ensureVisibleCollectionView()
      abilities = @model.get('abilities')
      if !abilities.can_attach
        @ui.manageLink.hide()

        # TODO: Remove this
      #@trigger('show:new')

    navigateToAssetDetail: (assetId) ->
      if @courseMapContext
        url = "courses/#{@courseId}/evaluations/assets/#{assetId}"
      else
        url = "courses/#{@courseId}/assets/#{assetId}"
      Vocat.router.navigate(url, true)

    setupListeners: () ->
      @listenTo(@, 'hide:new', () =>
        @onHideNew()
      )
      @listenTo(@, 'show:new', () =>
        @onShowNew()
      )
      @listenTo(@, 'asset:detail', (args) =>
        @navigateToAssetDetail(args.asset)
      )
      @listenTo(@collection, 'reset', (e) =>
        @ensureVisibleCollectionView()
      )
      @listenTo(@, 'request:manage:visibility', (e) =>
        @trigger('announce:manage:visibility', @manageVisible)
      )
      @listenTo(@, 'prevent:manage:close', (e) =>
        @preventManageClose()
      )
      @listenTo(@, 'allow:manage:close', (e) =>
        @allowManageClose()
      )

    # @model is a submission model.
    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
      @courseMapContext = Marionette.getOption(@, 'courseMapContext')
      @courseId = Marionette.getOption(@, 'courseId')
      @setupListeners()
