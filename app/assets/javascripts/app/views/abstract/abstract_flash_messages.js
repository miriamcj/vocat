/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import { isObject, isArray, isString } from "lodash";
import ItemView from 'views/flash/flash_messages_item';
import FlashMessageCollection from 'collections/flash_message_collection';
import template from 'hbs!templates/flash/flash_messages';

export default class AbstractFlashMessages extends Marionette.CollectionView {
  constructor() {

    this.childView = ItemView;
    this.clearOnAdd = false;
    this.template = template;
    this.className = 'alerts';
    this.childViewContainer = '[data-behavior="flash-container"]';
  }

  initialize() {
    this.collection = Marionette.getOption(this, 'collection');
    if (!this.collection) {
      this.collection = new FlashMessageCollection([], {});
    }

    this.vent = Marionette.getOption(this, 'vent');
    this.clearOnAdd = Marionette.getOption(this, 'clearOnAdd');

    this.listenTo(this.vent, 'error:add', flashMessage => {
      return this.processMessage(flashMessage);
    });

    return this.listenTo(this.vent, 'error:clear', flashMessage => {
      return this.collection.reset();
    });
  }

  // This method is meant to allow direct display of server-side RAILS model validation errors.
  // The flashMessage can look like any of the following:
  //
  // { level: 'level', lifetime: 5000, msg: 'message' }
  // { level: 'level', lifetime: 5000, msg: { property1: 'property1 message', property2: 'property2 message' }}
  // { level: 'level', lifetime: 5000, msg: { property1: ['message1', 'message2'], property2: ['message1', 'message2']}
  //
  // Only the third example, which is what rails returns, is currently in use AFAIK
  processMessage(flashMessage) {
    let level, lifetime;
    if (isObject(flashMessage.msg) || isArray(flashMessage.msg)) {
      if (flashMessage.level != null) { ({ level } = flashMessage); } else { level = 'notice'; }
      if (flashMessage.lifetime != null) { ({ lifetime } = flashMessage); } else { lifetime = null; }
      if (isArray(flashMessage.msg)) {
        if (flashMessage.msg.length > 0) {
          return this.addMessage(level, flashMessage.msg, null, lifetime);
        }
      } else if (!isString(flashMessage.msg) && isObject(flashMessage.msg)) {
        return flashMessage.msg.forEach((text, property) => {
          if (property === 'base') {
            return this.addMessage(level, text, null, lifetime);
          } else {
            return this.addMessage(level, `${property.charAt(0).toUpperCase() + property.slice(1)} ${text}`, null, lifetime);
          }
        });
      } else {
        return this.addMessage(level, flashMessage.msg, null, lifetime);
      }
    } else {
      return this.addMessage(flashMessage.level, flashMessage.msg, flashMessage.property, flashMessage.lifetime);
    }
  }

  addMessage(level, msg, property = null, lifetime) {
    if (level == null) { level = 'notice'; }
    if (msg == null) { msg = ''; }
    if (lifetime == null) { lifetime = false; }
    const m = {
      msg,
      level,
      property,
      lifetime
    };
    if (this.clearOnAdd === true) { this.collection.reset(); }
    return this.collection.add(m);
  }
}
