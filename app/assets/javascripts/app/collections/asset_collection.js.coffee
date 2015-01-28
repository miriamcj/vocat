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
      c = asset.get('listing_order')
      parseInt(c)

    url: '/api/v1/assets'

    initialize: (models, options) ->
      if options && options.hasOwnProperty('submissionId')
        @submissionId = options.submissionId
      @setupListeners()

    setupListeners: () ->
      @listenTo(@, 'add', (model) =>
        model.set('submission_id', @submissionId)
      )

