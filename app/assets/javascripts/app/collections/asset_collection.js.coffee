define [
  'backbone',
  'models/asset'
], (
  Backbone, AssetModel
) ->

  class AssetCollection extends Backbone.Collection

    model: AssetModel

    comparator: (asset) ->
      asset.get('listing_order_position')

    url: '/api/v1/assets'
