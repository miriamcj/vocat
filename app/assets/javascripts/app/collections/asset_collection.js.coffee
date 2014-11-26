define [
  'backbone',
  'models/asset'
], (
  Backbone, AssetModel
) ->

  class AssetCollection extends Backbone.Collection

    submissionId: null
    model: AssetModel

    comparator: (asset) ->
      asset.get('listing_order_position')

    url: '/api/v1/assets'

    initialize: (models, options) ->
      @submissionId = options.submissionId
      @setupListeners()

    setupListeners: () ->
      @listenTo(@, 'add', (model) =>
        model.set('submission_id', @submissionId)
      )

