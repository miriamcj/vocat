/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import VocatController from 'controllers/vocat_controller';
import FlashMessageCollection from 'collections/flash_message_collection';
import FlashMessagesView from 'views/flash/flash_messages';

export default class GlobalFlashController extends VocatController.extend({
  collections: {
    globalFlash: new FlashMessageCollection([], {})
  }
}) {
  show() {
    const view = new FlashMessagesView({vent: window.Vocat.vent, collection: this.collections.globalFlash});
    return window.Vocat.globalFlash.show(view);
  }
};
