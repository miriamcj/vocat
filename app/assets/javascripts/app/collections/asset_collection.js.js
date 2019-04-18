define [
  'backbone',
  'models/asset'
], (Backbone, AssetModel) ->
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

    highIndex: () ->
      @length - 1

    lowIndex: () ->
      0

    getPreviousModel: (model) ->
      index = @indexOf(model)
      if index - 1 >= @lowIndex()
        @at(index - 1)
      else
        null

    getNextModel: (model) ->
      index = @indexOf(model)
      if index + 1 <= @highIndex()
        @at(index + 1)
      else
        null

    getPositionBetween: (low, high) ->
      Math.round(low + ((high - low) / 2))

    moveUp: (model) ->
      previousModel = @getPreviousModel(model)
      if previousModel
        betweenHigh = previousModel.get('listing_order')
        previousPreviousModel = @getPreviousModel(previousModel)
        if previousPreviousModel
          betweenLow = previousPreviousModel.get('listing_order')
        else
          betweenLow = -8388607
        newPosition = @getPositionBetween(betweenLow, betweenHigh)
        model.set('listing_order', newPosition)
        @sort()
      else
        # Can't move past itself. Do nothing.

    moveDown: (model) ->
      nextModel = @getNextModel(model)
      if nextModel
        betweenLow = nextModel.get('listing_order')
        nextNextModel = @getNextModel(nextModel)
        if nextNextModel
          betweenHigh = nextNextModel.get('listing_order')
        else
          betweenHigh = 8388607
        newPosition = @getPositionBetween(betweenLow, betweenHigh)
        model.set('listing_order', newPosition)
        @sort()
      else
        # Can't move past itself. Do nothing.

    setupListeners: () ->
      @listenTo(@, 'add', (model) =>
        model.set('submission_id', @submissionId)
      )
      @listenTo(@, 'sort', (e) ->
        @each((model, index) ->
          model.set('listing_order_position', index)
        )
      )
