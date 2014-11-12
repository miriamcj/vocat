define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/asset_collection_empty')

  class AssetCollectionEmpty extends Marionette.ItemView

    template: template

    ui: {
      manageLink: '[data-behavior="empty-manage-link"]'
    }

    triggers: {
      'click @ui.manageLink': 'show:new'
    }

    onShowNew: () ->
      @vent.trigger('show:new')

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
