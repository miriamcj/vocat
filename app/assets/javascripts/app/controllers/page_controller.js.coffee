define [
  'marionette', 'controllers/vocat_controller', 'views/page/help_test', 'models/cell',
  'views/property_editor/long_text_input'
], (Marionette, VocatController, HelpTestView, CellModel, LongTextInputView) ->
  class PageController extends VocatController

    initialize: () ->

    helpDev: () ->
      view = new HelpTestView({})
      Vocat.main.show view

    modalDev: () ->
      model = new CellModel({description: 'this is the description'})
      Vocat.vent.trigger('modal:open', new LongTextInputView({model: model, vent: Vocat.vent}))
