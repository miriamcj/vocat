define [
  'marionette', 'controllers/vocat_controller', 'views/page/help_test'
], (
  Marionette, VocatController, HelpTestView
) ->

  class PageController extends VocatController

    help: () ->
      view = new HelpTestView({})
      Vocat.main.show view
