/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import { bindAll } from "lodash";
import template from 'templates/modal/modal_markdown_overview.hbs';

export default class ModalMarkdownOverview extends Marionette.ItemView {
  constructor(options) {
    super(options);

    this.template = template;
    this.modalWidth = '90%';
    this.modalMaxWidth = '800';

    this.triggers = {
      'click [data-behavior="dismiss"]': 'click:dismiss'
    };
  }

  onKeyUp(e) {
    const code = (e.keyCode != null) ? e.keyCode : e.which;
    if (code === 27) { return this.onClickDismiss(); }
  }

  onClickDismiss() {
    return Vocat.vent.trigger('modal:close');
  }

  onDestroy() {
    return $(window).off('keyup', this.onKeyUp);
  }

  initialize(options) {
    bindAll(this, 'onKeyUp');
    return $(window).on('keyup', this.onKeyUp);
  }
}
