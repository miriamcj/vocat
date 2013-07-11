define [
  'marionette', 'controllers/vocat_controller', 'collections/flash_message_collection', 'views/flash/flash_messages'
], (
  Marionette, VocatController, FlashMessageCollection, FlashMessagesView
) ->

  class GlobalFlashController extends VocatController

    collections: {
      globalFlash: new FlashMessageCollection([], {})
    }

    show: () ->
      view = new FlashMessagesView({vent: Vocat, collection: @collections.globalFlash})
      Vocat.globalFlash.show view
