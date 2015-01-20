define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/new_asset_footer')

  class NewAssetFooter extends Marionette.ItemView

    template: template

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
