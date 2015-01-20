define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/asset_collection_child')
  ModalConfirmView = require('views/modal/modal_confirm')
  ShortTextInputView = require('views/property_editor/short_text_input')

  class AssetCollectionChild extends Marionette.ItemView

    template: template

    attributes: {
        'data-behavior': 'sortable-item'
        'class': 'page-section--subsection page-section--subsection-ruled asset-collection-item'
    }

    events: {
      "drop": "onDrop"
    }

    ui: {
      destroy: '[data-behavior="destroy"]'
      move: '[data-behavior="move"]'
      show: '[data-behavior="show"]'
      rename: '[data-behavior="rename"]'
    }

    modelEvents: {
      "change:name": "render"
    }

    triggers: {
      'click @ui.destroy': 'destroyModel'
      'click @ui.show': 'showModel'
      'click @ui.rename': 'renameModel'
    }

    onShowModel: () ->
      @vent.trigger('asset:detail', {asset: @model.id})

    onDrop: (e, i) ->
      @trigger("update:sort",[@model, i])

    onRenameModel: () ->
      onSave = () =>
        @model.save({}, {
          success: () =>
            Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: 'The asset has been updated.'})
            @render()
          , error: () =>
            Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: 'Unable to update asset title.'})
        })
      Vocat.vent.trigger('modal:open', new ShortTextInputView({model: @model, vent: @vent, onSave: onSave, property: 'name', saveLabel: 'Update asset title', inputLabel: 'What would you like to call this asset?'}))

    onDestroyModel: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Deleted assets cannot be recovered. All annotations for this asset will also be deleted.',
        confirmEvent: 'confirm:destroy:model',
        dismissEvent: 'dismiss:destroy:model'
      }))

    onConfirmDestroyModel: () ->
      @model.destroy(success: () =>
        Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: 'The asset has been deleted.'})
      )

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
      @listenTo(@vent, 'show:new', (e) =>
        @showManageUi()
      )
      @listenTo(@vent, 'hide:new', (e) =>
        @hideManageUi()
      )
      @listenTo(@vent, 'announce:manage:visibility', (visible) =>
        if visible == true
          @showManageUi()
        else
          @hideManageUi()
      )

    hideManageUi: () ->
      @ui.destroy.hide()
      @ui.move.hide()
      @ui.rename.hide()

    showManageUi: () ->
      @ui.destroy.show()
      @ui.move.show()
      @ui.rename.show()

    requestManageVisibilityState: () ->
      @vent.trigger('request:manage:visibility')

    onRender: () ->
      @requestManageVisibilityState()

