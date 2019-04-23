/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */




import { bindAll } from "lodash";

import template from 'templates/modal/modal_error.hbs';

export default class ModalErrorView extends Marionette.ItemView {
  constructor() {

    this.template = template;

    this.message = 'An error occured.';
    this.dismissLabel = 'Dismiss';
    this.dismissEvent = 'modal:dismiss';

    this.triggers = {
      'click [data-behavior="dismiss"]': 'click:dismiss'
    };
  }

  onKeyUp(e) {
    const code = (e.keyCode != null) ? e.keyCode : e.which;
    if (code === 13) { this.onClickConfirm(); }
    if (code === 27) { return this.onClickDismiss(); }
  }

  onClickDismiss() {
    this.vent.triggerMethod(Marionette.getOption(this, 'dismissEvent'));
    return Vocat.vent.trigger('modal:destroy');
  }

  serializeData() {
    return {
    message: Marionette.getOption(this, 'message'),
    dismissLabel: Marionette.getOption(this, 'dismissLabel')
    };
  }

  onDestroy() {
    // Gotta be sure to unbind this event, so that views that have been closed out are no longer triggered.
    // Normally, marionette does this with listenTo, which registers events, but in this case we have to
    // do it differently because we're binding to a global object (window)
    return $(window).off('keyup', this.onKeyUp);
  }

  initialize(options) {
    this.vent = options.vent;
    bindAll(this, 'onKeyUp');
    return $(window).on('keyup', this.onKeyUp);
  }
}
