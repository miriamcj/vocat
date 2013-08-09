define [
  'marionette', 'controllers/vocat_controller', 'views/page/help_test', 'models/cell', 'views/rubric/cell_edit'
], (
  Marionette, VocatController, HelpTestView, CellModel, CellEditView
) ->

  class PageController extends VocatController

    helpDev: () ->
      view = new HelpTestView({})
      Vocat.main.show view

    modalDev: () ->
      model = new CellModel({description: 'this is the description'})
      console.log Vocat.vent, 'controller'
      Vocat.vent.trigger('modal:open', new CellEditView({model: model, vent: Vocat.vent}))
