define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/new_asset')
  Asset = require('models/asset')

  class NewAsset extends Marionette.ItemView

    template: template

    ui: {
      testNewButton: '[data-behavior="test-new-asset"]'
      hideManage: '[data-behavior="hide-manage"]'
    }

    triggers: {
      'click @ui.testNewButton': 'test:new'
      'click @ui.hideManage': 'hide:new'
    }

    onHideNew: () ->
      @vent.trigger('hide:new')

    onTestNew: () ->
      asset = new Asset({
        name: 'A new asset',
        thumb: 'http://1389blog.com/pix/happy-cat-wallpaper-thumbnail.jpg'
        listing_order_position: @collection.length
      })
      @collection.add(asset)

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')



