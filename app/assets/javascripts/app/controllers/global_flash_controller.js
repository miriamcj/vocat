/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'backbone.marionette';

import VocatController from 'controllers/vocat_controller';
import FlashMessageCollection from 'collections/flash_message_collection';
import FlashMessagesView from 'views/flash/flash_messages';

export default class GlobalFlashController extends VocatController {
  constructor() {

    // Server-side flash messages are bootstrapped into the HTML source and picked up by the initialize method in this
    // controller's parent. If you add an initialize method to this controller, be sure to call the parent's initialize
    // method to kick off thisbootstrapping.
    this.collections = {
      globalFlash: new FlashMessageCollection([], {})
    };
  }

  show() {
    const view = new FlashMessagesView({vent: Vocat.vent, collection: this.collections.globalFlash});
    return Vocat.globalFlash.show(view);
  }
};
