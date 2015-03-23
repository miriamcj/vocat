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
      "asset:dropped": "onDrop"
    }

    ui: {
      destroy: '[data-behavior="destroy"]'
      moveUp: '[data-behavior="move-up"]'
      moveDown: '[data-behavior="move-down"]'
      show: '[data-behavior="show"]'
      rename: '[data-behavior="rename"]'
      showOnManage: '[data-behavior="show-on-manage"]'
      hideOnManage: '[data-behavior="hide-on-manage"]'
    }

    modelEvents: {
      "change:name": "render"
    }

    triggers: {
      'click @ui.destroy': 'destroyModel'
      'click @ui.show': 'showModel'
      'click @ui.rename': 'renameModel'
      'click @ui.moveUp': 'moveUp'
      'click @ui.moveDown': 'moveDown'
    }

    onShowModel: () ->
      if @model.get('attachment_state') == 'processed'
        @vent.trigger('asset:detail', {asset: @model.id})
      else
        Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: 'Media is still being processed and is not yet available. Check back soon or reload the page to see if processing has completed.'})

    onMoveUp: () ->
      @model.collection.moveUp(@model)
      @model.save()

    onMoveDown: () ->
      @model.collection.moveDown(@model)
      @model.save()

    onRenameModel: () ->
      onSave = () =>
        @model.save({}, {
          success: () =>
            Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: 'Media successfully updated.'})
            @render()
          , error: () =>
            Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: 'Unable to update media title.'})
        })
      Vocat.vent.trigger('modal:open', new ShortTextInputView({model: @model, vent: @vent, onSave: onSave, property: 'name', saveLabel: 'Update Title', inputLabel: 'What would you like to call this media?'}))

    onDestroyModel: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Deleted media cannot be recovered. All annotations for this media will also be deleted.',
        confirmEvent: 'confirm:destroy:model',
        dismissEvent: 'dismiss:destroy:model'
      }))

    onConfirmDestroyModel: () ->
      @model.destroy(success: () =>
        Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: 'The media has been deleted.'})
      )

    serializeData: () ->
      sd = super()
      sd.annotationCount = @model.get('annotations').length
      sd

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
      @listenTo(@vent, 'show:new', (e) =>
        @showManageUi()
      )
      @listenTo(@vent, 'hide:new', (e) =>
        @hideManageUi()
      )
      @listenTo(@model, 'change:attachment_state', () =>
        @render()
      )
      @listenTo(@vent, 'announce:state', (state) =>
        if state == 'manage'
          @showManageUi()
        else
          @hideManageUi()
      )
      @listenTo(@model.collection, 'add remove', (model) =>
        if model != @model && @model != null
          @checkMoveButtonVisibility()
      )

    checkMoveButtonVisibility: () ->
      if @model && @model.collection.length > 1
        @ui.moveUp.removeClass('disabled')
        @ui.moveDown.removeClass('disabled')
      else
        @ui.moveUp.hide()
        @ui.moveDown.addClass('disabled')
      if @model && @model.collection.indexOf(@model) == 0
        @ui.moveUp.addClass('disabled')
      if @model && @model.collection.indexOf(@model) == @model.collection.length - 1
        @ui.moveDown.addClass('disabled')

    hideManageUi: () ->
      @ui.showOnManage.hide()
      @ui.hideOnManage.show()

    showManageUi: () ->
      @ui.showOnManage.show()
      @ui.hideOnManage.hide()

    requestManageVisibilityState: () ->
      @vent.trigger('request:state')

    onRender: () ->
      @requestManageVisibilityState()
      @checkMoveButtonVisibility()
