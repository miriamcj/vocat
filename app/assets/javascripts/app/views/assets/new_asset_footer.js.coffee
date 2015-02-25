define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/new_asset_footer')

  class NewAssetFooter extends Marionette.ItemView

    template: template

    ui: {
      stopManagingLink: '[data-behavior="stop-manage-link"]'
    }

    preventManageClose: () ->
      @ui.stopManagingLink.css(display: 'none')

    allowManageClose: () ->
      @ui.stopManagingLink.css(display: 'inline-block')

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')

      @listenTo(@, 'prevent:manage:close', (e) =>
        @preventManageClose()
      )
      @listenTo(@, 'allow:manage:close', (e) =>
        @allowManageClose()
      )