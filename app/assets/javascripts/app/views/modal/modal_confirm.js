/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */




import { bindAll } from "lodash";

import template from 'templates/modal/modal_confirm.hbs';

export default class ModalConfirmView extends Marionette.ItemView.extend({
  template: template,
  headerLabel: 'Are You Sure?',
  confirmLabel: 'Yes, Proceed',
  dismissLabel: 'Cancel',
  confirmEvent: 'modal:confirm',
  confirmHref: null,
  dismissEvent: 'modal:dismiss',

  triggers: {
    'click [data-behavior="confirm"]': 'click:confirm',
    'click [data-behavior="dismiss"]': 'click:dismiss'
  }
}) {
  onKeyUp(e) {
    const code = (e.keyCode != null) ? e.keyCode : e.which;
    if (code === 13) { this.onClickConfirm(); }
    if (code === 27) { return this.onClickDismiss(); }
  }

  onClickConfirm() {
    if (Marionette.getOption(this, 'confirmElement') != null) {
      window.Vocat.vent.trigger('modal:close');
      const $el = Marionette.getOption(this, 'confirmElement');
      $el.addClass('modal-blocked');
      $el.click();
      return $el.removeClass('modal-blocked');
    } else {
      this.vent.triggerMethod(Marionette.getOption(this, 'confirmEvent'), this.model);
      return window.Vocat.vent.trigger('modal:close');
    }
  }

  onClickDismiss() {
    this.vent.triggerMethod(Marionette.getOption(this, 'dismissEvent'));
    return window.Vocat.vent.trigger('modal:close');
  }

  serializeData() {
    return {
    descriptionLabel: Marionette.getOption(this, 'descriptionLabel'),
    confirmLabel: Marionette.getOption(this, 'confirmLabel'),
    dismissLabel: Marionette.getOption(this, 'dismissLabel'),
    headerLabel: Marionette.getOption(this, 'headerLabel')
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