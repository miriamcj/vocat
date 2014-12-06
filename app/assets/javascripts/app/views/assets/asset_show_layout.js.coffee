define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/asset_show_layout')
  AssetCollectionView = require('views/assets/asset_collection')

  class AssetShowLayout extends Marionette.LayoutView

    template: template

    ui: {
      close: '[data-behavior="close"]'
    }

    triggers: {
      'click @ui.close': 'click:close'
    }

    onClickClose: () ->
      @vent.triggerMethod('open:detail:submission', @model.get('submission_id'))

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
