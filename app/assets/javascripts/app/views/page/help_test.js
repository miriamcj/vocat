/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import template from 'hbs!templates/page/help_test';

export default class FlashMessagesItem extends Marionette.ItemView {
  constructor() {

    this.template = template;
    this.events = {
      'mouseenter [data-help]': 'onHelpShow',
      'mouseleave [data-help]': 'onHelpHide'
    };
  }

  onHelpShow(event) {
    const target = $(event.currentTarget);
    const orientation = target.attr('data-help-orientation');
    return Vocat.vent.trigger('help:show', {on: target, orientation, key: target.attr('data-help')});
  }

  onHelpHide(event) {
    const target = $(event.currentTarget);
    return Vocat.vent.trigger('help:hide', {on: target, key: target.attr('data-help')});
  }
};

