define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/asset_collection_child')

  class AssetCollectionChild extends Marionette.ItemView

    template: template

    attributes: {
        'data-behavior': 'sortable-item'
    }

    events: {
      "drop": "onDrop"
    }

    ui: {
      destroy: '[data-behavior="destroy"]'
      move: '[data-behavior="move"]'
    }

    triggers: {
      'click @ui.destroy': 'delete'
    }

    onDrop: (e, i) ->
      @trigger("update:sort",[@model, i]);

    onDelete: () ->
      @model.destroy()

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
