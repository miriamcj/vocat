define [
  'marionette', 'controllers/vocat_controller', 'collections/flash_message_collection', 'views/flash/flash_messages'
], (
  Marionette, VocatController, FlashMessageCollection, FlashMessagesView
) ->

  class GlobalFlashController extends VocatController

    # Server-side flash messages are bootstrapped into the HTML source and picked up by the initialize method in this
    # controller's parent. If you add an initialize method to this controller, be sure to call the parent's initialize
    # method to kick off thisbootstrapping.
    collections: {
      globalFlash: new FlashMessageCollection([], {})
    }

    show: () ->
      view = new FlashMessagesView({vent: Vocat, collection: @collections.globalFlash})
      Vocat.globalFlash.show view
