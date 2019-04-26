/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import { bindAll } from "lodash";
import template from 'templates/modal/modal_project_description.hbs';

export default class ModalProjectDescription extends Marionette.ItemView.extend({
  template: template,
  modalWidth: '90%',
  modalMaxWidth: '800',

  triggers: {
    'click [data-behavior="dismiss"]': 'click:dismiss'
  }
}) {
  onKeyUp(e) {
    const code = (e.keyCode != null) ? e.keyCode : e.which;
    if (code === 27) { return this.onClickDismiss(); }
  }

  onClickDismiss() {
    return window.Vocat.vent.trigger('modal:close');
  }

  onDestroy() {
    return $(window).off('keyup', this.onKeyUp);
  }

  initialize(options) {
    bindAll(this, 'onKeyUp');
    return $(window).on('keyup', this.onKeyUp);
  }
}