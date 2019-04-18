/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define([
  'marionette', 'controllers/vocat_controller', 'views/page/help_test', 'models/cell',
  'views/property_editor/long_text_input'
], function(Marionette, VocatController, HelpTestView, CellModel, LongTextInputView) {
  let PageController;
  return (PageController = class PageController extends VocatController {

    initialize() {}

    helpDev() {
      const view = new HelpTestView({});
      return Vocat.main.show(view);
    }

    modalDev() {
      const model = new CellModel({description: 'this is the description'});
      return Vocat.vent.trigger('modal:open', new LongTextInputView({model, vent: Vocat.vent}));
    }
  });
});
