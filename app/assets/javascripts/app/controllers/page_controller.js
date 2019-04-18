/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import VocatController from 'controllers/vocat_controller';
import HelpTestView from 'views/page/help_test';
import CellModel from 'models/cell';
import LongTextInputView from 'views/property_editor/long_text_input';
let PageController;

export default PageController = class PageController extends VocatController {

  initialize() {}

  helpDev() {
    const view = new HelpTestView({});
    return Vocat.main.show(view);
  }

  modalDev() {
    const model = new CellModel({description: 'this is the description'});
    return Vocat.vent.trigger('modal:open', new LongTextInputView({model, vent: Vocat.vent}));
  }
};
