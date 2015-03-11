define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/assets_layout')
  AssetCollectionView = require('views/assets/asset_collection')
  NewAssetView = require('views/assets/new_asset')
  NewAssetFooterView = require('views/assets/new_asset_footer')
  AssetModel= require('models/asset')
  AssetDetail = require('views/assets/asset_detail')
  ModalConfirmView = require('views/modal/modal_confirm')

  class AssetsLayout extends Marionette.LayoutView

    template: template
    state: 'list'
    canAttach: false

    ui: {
      detailHeader: '[data-behavior="detail-header"]'
      newAssetContainer: '[data-behavior="new-asset-container"]'
      manageLink: '[data-behavior="manage-link"]'
      stopManagingLink: '[data-behavior="stop-manage-link"]'
      closeLink: '[data-behavior="close-link"]'
    }

#    collectionEvents: {
#      'add': 'ensureVisibleCollectionView'
#      'remove': 'hideEmptyCollectionViewIfNewIsVisible'
#    }

    triggers: {
      'click @ui.stopManagingLink': 'request:state:list'
      'click @ui.manageLink': 'request:state:manage'
      'click @ui.closeLink': 'request:state:list'
    }

    regions: {
      assets: '[data-region="asset-collection"]'
      newAsset: '[data-region="asset-new"]'
      newAssetFooter: '[data-region="asset-new-footer"]'
    }

    setState: (state, assetId = null) ->

      if @state == 'uploading' && state == 'detail'
        Vocat.vent.trigger('error:add', {level: 'notice', clear: true, lifetime: '5000',  msg: 'Please wait for your upload to complete before viewing media.'})
        return

      @state = state
      switch state
        when 'list'
          @handleStateList()
        when 'firstAdd'
          @handleStateFirstAdd()
        when 'manage'
          @handleStateManage()
        when 'detail'
          @handleStateDetail(assetId)
        when 'uploading'
          @handleStateUploading()
      @trigger('announce:state', @state)

    handleCollectionAddRemove: () ->
      if @collection.length > 0 && @state == 'firstAdd'
        @setState('manage')
      if @collection.length == 0 && @state == 'manage'
        @setState('firstAdd')

    handleStateUploading: () ->
      @newAssetFooter.empty()
      @_updateUIStateUploading()

    handleStateList: () ->
      if @newAssetFooter.currentView?
        @newAssetFooter.$el.fadeOut(200)
      if @newAsset.currentView?
        @newAsset.$el.fadeOut(200, () =>
          @newAsset.empty()
          @assets.show(@_assetCollectionView())
        )
      else
        @assets.show(@_assetCollectionView())

      @_updateUIStateList()

    handleStateFirstAdd: () ->
      @assets.empty()
      @newAsset.show(@_newAssetView())
      @newAsset.$el.fadeIn(200)
      @newAssetFooter.empty()
      @_updateUIStateFirstAdd()

    handleStateManage: () ->
      unless @newAsset.currentView?
        @newAsset.show(@_newAssetView())
      unless @newAssetFooter.currentView?
        @newAssetFooter.show(@_newAssetFooterView())
      @newAsset.$el.fadeIn(200)
      @newAssetFooter.$el.fadeIn(200)
      @assets.show(@_assetCollectionView())
      @_updateUIStateManage()

    handleStateDetail: (assetId) ->
      asset = new AssetModel({id: assetId})
      asset.fetch({
        success: () =>
          if asset.get('name')
            label = "/ #{asset.get('name')}"
          else
            family = asset.get('family')
            family = family.charAt(0).toUpperCase() + family.slice(1)
            label = "/ #{family} media"
          @ui.detailHeader.html(label)
          @newAsset.empty()
          @newAssetFooter.empty()
          @assets.show(@_assetDetail(asset))
          @_updateUIStateDetail()
      })

    onRequestStateUploading: () ->
      @setState('uploading')

    onRequestStateManage: () ->
      if @collection.length == 0
        @setState('firstAdd')
      else
        @setState('manage')

    onRequestStateDetail: () ->
      @setState('detail')

    onRequestStateList: () ->
      @setState('list')

    renderCollectionView: () ->
      if @assets.currentView?
        @assets.currentView.render()

    _updateUIStateList: () ->
      @ui.detailHeader.hide()
      @_hideButton(@ui.closeLink)
      @_hideButton(@ui.stopManagingLink)
      @_showButton(@ui.manageLink)

    _updateUIStateUploading: () ->
      @ui.detailHeader.hide()
      @_hideButton(@ui.closeLink)
      @_hideButton(@ui.stopManagingLink)
      @_hideButton(@ui.manageLink)

    _updateUIStateFirstAdd: () ->
      @ui.detailHeader.hide()
      @$el.addClass('empty-list')
      @_hideButton(@ui.closeLink)
      @_showButton(@ui.stopManagingLink)
      @_hideButton(@ui.manageLink)

    _updateUIStateManage: () ->
      @ui.detailHeader.hide()
      @$el.removeClass('empty-list')
      @_hideButton(@ui.closeLink)
      @_showButton(@ui.stopManagingLink)
      @_hideButton(@ui.manageLink)

    _updateUIStateDetail: () ->
      @ui.detailHeader.show()
      @_showButton(@ui.closeLink)
      @_hideButton(@ui.stopManagingLink)
      @_hideButton(@ui.manageLink)

    _assetCollectionView: () ->
      new AssetCollectionView({collection: @collection, vent: @, project: @model.project(), abilities: @model.get('abilities')})

    _newAssetView: () ->
      new NewAssetView({collection: @collection, model: @model.project(), vent: @})

    _newAssetFooterView: () ->
      new NewAssetFooterView({vent: @})

    _assetDetail: (asset) ->
      new AssetDetail({courseId: @courseId, model: asset, context: 'submission'})

    _hideButton: (button) ->
      button.css(display: 'none')

    _showButton: (button) ->
      button.css(display: 'inline-block')

    setupListeners: () ->
      @listenTo(@, 'asset:detail', (args) =>
        @setState('detail', args.asset)
      )
      @listenTo(@, 'request:state', (args) =>
        @trigger('announce:state', @state)
      )
      @listenTo(@collection, 'reset', (e) =>
        @renderCollectionView()
      )
      @listenTo(@collection, 'add remove', (e) =>
        @handleCollectionAddRemove()
      )

    onRender: () ->
      @setState('list')

    # @model is a submission model.
    initialize: (options) ->
      @courseMapContext = Marionette.getOption(@, 'courseMapContext')
      @courseId = Marionette.getOption(@, 'courseId')
      abilities = @model.get('abilities')
      @canAttach = abilities.can_attach
      @setupListeners()

      # TODO: Remove this
      @setState('detail', 275)
