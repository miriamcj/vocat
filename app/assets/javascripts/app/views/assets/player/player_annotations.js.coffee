define (require) ->

  Marionette = require('marionette')
  ItemView = require('views/assets/player/player_annotations_item')

  class PlayerAnnotations extends Marionette.CollectionView

    template: _.template('')
    showTimePadding: 1
    hideTimePadding: .1

    tagName: 'ul'
    attributes: {
      class: 'annotations-overlay'
    }
    childView: ItemView

    childViewOptions: (model, index) ->
      {
        vent: @vent
        assetHasDuration: @model.hasDuration()
      }

    setupListeners: () ->

    initialize: (options) ->
      @collection = @model.annotations()
      @vent = options.vent
      @setupListeners()
