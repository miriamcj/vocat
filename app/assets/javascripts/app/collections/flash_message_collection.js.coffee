define ['backbone', 'models/flash_message'], (Backbone, FlashMessageModel) ->
  class FlashMessageCollection  extends Backbone.Collection

    model: FlashMessageModel

    initialize: () ->
      @listenTo @, 'remove', () -> console.log 'collection heard remove'