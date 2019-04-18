/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let AssetsLayout;
import Marionette from 'marionette';
import template from 'hbs!templates/assets/assets_layout';
import AssetCollectionView from 'views/assets/asset_collection';
import NewAssetView from 'views/assets/new_asset';
import NewAssetFooterView from 'views/assets/new_asset_footer';
import AssetModel from 'models/asset';
import AssetDetail from 'views/assets/asset_detail';
import ModalConfirmView from 'views/modal/modal_confirm';

export default AssetsLayout = (function() {
  AssetsLayout = class AssetsLayout extends Marionette.LayoutView {
    static initClass() {

      this.prototype.template = template;
      this.prototype.state = 'list';
      this.prototype.canAttach = false;

      this.prototype.ui = {
        assetCollectionHeader: '[data-behavior="asset-collection-header"]',
        detailHeader: '[data-behavior="detail-header"]',
        detailHeaderContent: '[data-behavior="detail-header-content"]',
        newAssetContainer: '[data-behavior="new-asset-container"]',
        manageLink: '[data-behavior="manage-link"]',
        stopManagingLink: '[data-behavior="stop-manage-link"]',
        closeLink: '[data-behavior="close-link"]'
      };

      this.prototype.triggers = {
        'click @ui.stopManagingLink': 'request:state:list',
        'click @ui.manageLink': 'request:state:manage',
        'click @ui.closeLink': 'request:state:list'
      };

      this.prototype.regions = {
        assets: '[data-region="asset-collection"]',
        newAsset: '[data-region="asset-new"]',
        newAssetFooter: '[data-region="asset-new-footer"]'
      };
    }

    setState(state, assetId = null) {
      if ((this.state === 'uploading') && (state === 'detail')) {
        Vocat.vent.trigger('error:add', {
          level: 'notice',
          clear: true,
          lifetime: '5000',
          msg: 'Please wait for your upload to complete before viewing media.'
        });
        return;
      }

      this.state = state;
      switch (state) {
        case 'list':
          this.handleStateList();
          break;
        case 'firstAdd':
          this.handleStateFirstAdd();
          break;
        case 'manage':
          this.handleStateManage();
          break;
        case 'detail':
          this.handleStateDetail(assetId);
          break;
        case 'uploading':
          this.handleStateUploading();
          break;
      }
      return this.trigger('announce:state', this.state);
    }

    handleCollectionAddRemove() {
      if ((this.collection.length > 0) && (this.state === 'firstAdd')) {
        this.setState('manage');
      }
      if ((this.collection.length === 0) && (this.state === 'manage')) {
        return this.setState('firstAdd');
      }
    }

    handleStateUploading() {
      this.navigateToSubmissionView();
      this.newAssetFooter.empty();
      return this._updateUIStateUploading();
    }

    handleStateList() {
      this.navigateToSubmissionView();
      if (this.newAssetFooter.currentView != null) {
        this.newAssetFooter.$el.fadeOut(200);
      }
      if (this.newAsset.currentView != null) {
        this.newAsset.$el.fadeOut(200, () => {
          this.newAsset.empty();
          return this.assets.show(this._assetCollectionView());
        });
      } else {
        this.assets.show(this._assetCollectionView());
      }

      return this._updateUIStateList();
    }

    handleStateFirstAdd() {
      this.navigateToSubmissionView();
      this.assets.empty();
      this.newAsset.show(this._newAssetView());
      this.newAsset.$el.fadeIn(200);
      this.newAssetFooter.empty();
      return this._updateUIStateFirstAdd();
    }

    navigateToSubmissionView() {
      return Vocat.router.navigate(`${this.model.detailUrl()}`, false);
    }

    handleStateManage() {
      this.navigateToSubmissionView();
      if (this.newAsset.currentView == null) {
        this.newAsset.show(this._newAssetView());
      }
      if (this.newAssetFooter.currentView == null) {
        this.newAssetFooter.show(this._newAssetFooterView());
      }
      this.newAsset.$el.fadeIn(200);
      this.newAssetFooter.$el.fadeIn(200);
      this.assets.show(this._assetCollectionView());
      return this._updateUIStateManage();
    }

    handleStateDetail(assetId) {
      const asset = new AssetModel({id: assetId});
      // TODO—do we need to ajax fetch this, if we already have it nested on the submission model?
      return asset.fetch({
        success: () => {
          if (asset.get('submission_id') !== this.model.id) {
            return this.setState('list');
          } else {
            let label;
            if (asset.get('name')) {
              label = `${asset.get('name')}`;
            } else {
              let family = asset.get('family');
              family = family.charAt(0).toUpperCase() + family.slice(1);
              label = `${family} media`;
            }
            this.ui.detailHeaderContent.html(label);
            this.newAsset.empty();
            this.newAssetFooter.empty();
            Vocat.router.navigate(`${this.model.detailUrl()}/asset/${assetId}`, false);
            this.assets.show(this._assetDetail(asset));
            return this._updateUIStateDetail();
          }
        }
      });
    }

    onRequestStateUploading() {
      return this.setState('uploading');
    }

    onRequestStateManage() {
      if (this.collection.length === 0) {
        return this.setState('firstAdd');
      } else {
        return this.setState('manage');
      }
    }

    onRequestStateDetail() {
      return this.setState('detail');
    }

    onRequestStateList() {
      return this.setState('list');
    }

    renderCollectionView() {
      if (this.assets.currentView != null) {
        return this.assets.currentView.render();
      }
    }

    _updateUIStateList() {
      this.ui.detailHeader.hide();
      this.ui.assetCollectionHeader.show();
      this._hideButton(this.ui.closeLink);
      this._hideButton(this.ui.stopManagingLink);
      if (this.canAttach) {
        return this._showButton(this.ui.manageLink);
      } else {
        return this._hideButton(this.ui.manageLink);
      }
    }

    _updateUIStateUploading() {
      this.ui.detailHeader.hide();
      this.ui.assetCollectionHeader.show();
      this._hideButton(this.ui.closeLink);
      this._hideButton(this.ui.stopManagingLink);
      return this._hideButton(this.ui.manageLink);
    }

    _updateUIStateFirstAdd() {
      this.ui.detailHeader.hide();
      this.ui.assetCollectionHeader.show();
      this.$el.addClass('empty-list');
      this._hideButton(this.ui.closeLink);
      this._showButton(this.ui.stopManagingLink);
      return this._hideButton(this.ui.manageLink);
    }

    _updateUIStateManage() {
      this.ui.detailHeader.hide();
      this.ui.assetCollectionHeader.show();
      this.$el.removeClass('empty-list');
      this._hideButton(this.ui.closeLink);
      this._showButton(this.ui.stopManagingLink);
      return this._hideButton(this.ui.manageLink);
    }

    _updateUIStateDetail() {
      this.ui.detailHeader.show();
      this.ui.assetCollectionHeader.hide();
      this._showButton(this.ui.closeLink);
      this._hideButton(this.ui.stopManagingLink);
      return this._hideButton(this.ui.manageLink);
    }

    _assetCollectionView() {
      return new AssetCollectionView({
        collection: this.collection,
        vent: this,
        project: this.model.project(),
        abilities: this.model.get('abilities')
      });
    }

    _newAssetView() {
      return new NewAssetView({collection: this.collection, model: this.model.project(), vent: this});
    }

    _newAssetFooterView() {
      return new NewAssetFooterView({vent: this});
    }

    _assetDetail(asset) {
      return new AssetDetail({courseId: this.courseId, model: asset, context: 'submission'});
    }

    _hideButton(button) {
      return button.css({display: 'none'});
    }

    _showButton(button) {
      return button.css({display: 'inline-block'});
    }

    setupListeners() {
      this.listenTo(this, 'asset:detail', args => {
        return this.setState('detail', args.asset);
      });
      this.listenTo(this, 'request:state', args => {
        return this.trigger('announce:state', this.state);
      });
      this.listenTo(this.collection, 'reset', e => {
        return this.renderCollectionView();
      });
      return this.listenTo(this.collection, 'add remove', e => {
        return this.handleCollectionAddRemove();
      });
    }

    onRender() {
      return this.setState('list');
    }

    // @model is a submission model.
    initialize(options) {
      this.courseMapContext = Marionette.getOption(this, 'courseMapContext');
      this.courseId = Marionette.getOption(this, 'courseId');
      const abilities = this.model.get('abilities');
      this.canAttach = abilities.can_attach;
      this.setupListeners();
      if (options.initialAsset) {
        return this.setState('detail', options.initialAsset);
      }
    }
  };
  AssetsLayout.initClass();
  return AssetsLayout;
})();
