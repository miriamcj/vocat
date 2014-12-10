define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/asset_collection_child')
  ModalConfirmView = require('views/modal/modal_confirm')

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
    }

    triggers: {
      'click @ui.destroy': 'destroyModel'
      'click @ui.show': 'showModel'
    }

    onShowModel: () ->
      @vent.trigger('asset:detail', {asset: @model.id})

    onDrop: (e, i) ->
      @trigger("update:sort",[@model, i])

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
        Vocat.vent.trigger('error:add', {level: 'error', msg: 'The asset has been deleted.'})
      )

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
