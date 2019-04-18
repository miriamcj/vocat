/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import template from 'hbs!templates/modal/modal_rubric';

export default ModalProjectDescription = (function() {
  ModalProjectDescription = class ModalProjectDescription extends Marionette.ItemView {
    static initClass() {

      this.prototype.template = template;
      this.prototype.modalWidth = '90%';
      this.prototype.modalMaxWidth = '1100';

      this.prototype.triggers = {
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
      _.bindAll(this, 'onKeyUp');
      return $(window).on('keyup', this.onKeyUp);
    }
  };
  ModalProjectDescription.initClass();
  return ModalProjectDescription;
})();
