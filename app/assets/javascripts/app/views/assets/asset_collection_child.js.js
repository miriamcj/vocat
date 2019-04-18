/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let AssetCollectionChild;
  const Marionette = require('marionette');
  const template = require('hbs!templates/assets/asset_collection_child');
  const ModalConfirmView = require('views/modal/modal_confirm');
  const ShortTextInputView = require('views/property_editor/short_text_input');

  return AssetCollectionChild = (function() {
    AssetCollectionChild = class AssetCollectionChild extends Marionette.ItemView {
      static initClass() {
  
        this.prototype.template = template;
  
        this.prototype.attributes = {
          'data-behavior': 'sortable-item',
          'class': 'page-section--subsection page-section--subsection-ruled asset-collection-item'
        };
  
        this.prototype.events = {
          "asset:dropped": "onDrop"
        };
  
        this.prototype.ui = {
          destroy: '[data-behavior="destroy"]',
          moveUp: '[data-behavior="move-up"]',
          moveDown: '[data-behavior="move-down"]',
          show: '[data-behavior="show"]',
          rename: '[data-behavior="rename"]',
          showOnManage: '[data-behavior="show-on-manage"]',
          hideOnManage: '[data-behavior="hide-on-manage"]'
        };
  
        this.prototype.modelEvents = {
          "change:name": "render"
        };
  
        this.prototype.triggers = {
          'click @ui.destroy': 'destroyModel',
          'click @ui.show': 'showModel',
          'click @ui.rename': 'renameModel',
          'click @ui.moveUp': 'moveUp',
          'click @ui.moveDown': 'moveDown'
        };
      }

      onShowModel() {
        if (this.model.get('attachment_state') === 'processed') {
          return this.vent.trigger('asset:detail', {asset: this.model.id});
        } else {
          return Vocat.vent.trigger('error:add', {
            level: 'error',
            clear: true,
            msg: 'Media is still being processed and is not yet available. Check back soon or reload the page to see if processing has completed.'
          });
        }
      }

      onMoveUp() {
        this.model.collection.moveUp(this.model);
        return this.model.save();
      }

      onMoveDown() {
        this.model.collection.moveDown(this.model);
        return this.model.save();
      }

      onRenameModel() {
        const onSave = () => {
          return this.model.save({}, {
            success: () => {
              Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: 'Media successfully updated.'});
              return this.render();
            }
            , error: () => {
              return Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: 'Unable to update media title.'});
            }
          });
        };
        return Vocat.vent.trigger('modal:open', new ShortTextInputView({
          model: this.model,
          vent: this.vent,
          onSave,
          property: 'name',
          saveLabel: 'Update Title',
          inputLabel: 'What would you like to call this media?'
        }));
      }

      onDestroyModel() {
        return Vocat.vent.trigger('modal:open', new ModalConfirmView({
          model: this.model,
          vent: this,
          descriptionLabel: 'Deleted media cannot be recovered. All annotations for this media will also be deleted.',
          confirmEvent: 'confirm:destroy:model',
          dismissEvent: 'dismiss:destroy:model'
        }));
      }

      onConfirmDestroyModel() {
        return this.model.destroy({success: () => {
          return Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: 'The media has been deleted.'});
        }
        });
      }

      serializeData() {
        const sd = super.serializeData();
        sd.annotationCount = this.model.get('annotations').length;
        return sd;
      }

      initialize(options) {
        this.vent = Marionette.getOption(this, 'vent');
        this.listenTo(this.vent, 'show:new', e => {
          return this.showManageUi();
        });
        this.listenTo(this.vent, 'hide:new', e => {
          return this.hideManageUi();
        });
        this.listenTo(this.model, 'change:attachment_state', () => {
          return this.render();
        });
        this.listenTo(this.vent, 'announce:state', state => {
          if (state === 'manage') {
            return this.showManageUi();
          } else {
            return this.hideManageUi();
          }
        });
        return this.listenTo(this.model.collection, 'add remove', model => {
          if ((model !== this.model) && (this.model !== null)) {
            return this.checkMoveButtonVisibility();
          }
        });
      }

      checkMoveButtonVisibility() {
        if (this.model && (this.model.collection.length > 1)) {
          this.ui.moveUp.removeClass('disabled');
          this.ui.moveDown.removeClass('disabled');
        } else {
          this.ui.moveUp.hide();
          this.ui.moveDown.addClass('disabled');
        }
        if (this.model && (this.model.collection.indexOf(this.model) === 0)) {
          this.ui.moveUp.addClass('disabled');
        }
        if (this.model && (this.model.collection.indexOf(this.model) === (this.model.collection.length - 1))) {
          return this.ui.moveDown.addClass('disabled');
        }
      }

      hideManageUi() {
        this.ui.showOnManage.hide();
        return this.ui.hideOnManage.show();
      }

      showManageUi() {
        this.ui.showOnManage.show();
        return this.ui.hideOnManage.hide();
      }

      requestManageVisibilityState() {
        return this.vent.trigger('request:state');
      }

      onRender() {
        this.requestManageVisibilityState();
        return this.checkMoveButtonVisibility();
      }
    };
    AssetCollectionChild.initClass();
    return AssetCollectionChild;
  })();
});