/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import { $ } from "jquery";

import { bind } from "lodash";

import template from 'hbs!templates/modal/modal_layout';

export default class ModalLayout extends Marionette.LayoutView {
  constructor() {

    this.template = template;

    this.attributes = {
      style: 'display: none;'
    };

    this.triggers = {
      'click [data-behavior="modal-close"]': 'click:modal:close'
    };

    this.regions = {
      content: '[data-region="content"]'
    };
  }

  onClickModalClose() {
    return this.closeModal();
  }

  initialize(options) {
    this.vent = Vocat.vent;
    this.$el.hide();

    this.listenTo(this.vent, 'modal:open', view => {
      this.view = view;
      this.updateContent(view);
      return this.open();
    });

    return this.listenTo(this.vent, 'modal:close', () => {
      return this.closeModal();
    });
  }

  updateContent(view) {
    if (view.modalWidth != null) {
      this.modalWidth = view.modalWidth;
    } else {
      this.modalWidth = '400px';
    }
    if (view.modalMaxWidth != null) {
      this.modalMaxWidth = view.modalMaxWidth;
    }
    return this.content.show(view);
  }

  closeModal() {
    this.vent.trigger('modal:before:close');
    this.content.reset();
    this.ensureBackdrop().fadeOut(250);
    this.$el.hide();
    return this.vent.trigger('modal:after:close');
  }

  open() {
    this.vent.trigger('modal:before:show');
    Backbone.Wreqr.radio.channel('global').vent.trigger('user:action');
    this.showBackdrop();
    this.centerModal();
    this.$el.show();
    this.vent.trigger('modal:after:show');
    return this.view.trigger('modal:after:show');
  }

  centerModal() {
    this.$el.outerWidth(this.modalWidth);
    let w = this.$el.outerWidth();
    let h = this.$el.outerHeight();
    if (this.modalMaxWidth && (w > this.modalMaxWidth)) {
      this.$el.outerWidth(this.modalMaxWidth);
      w = this.$el.outerWidth();
      h = this.$el.outerHeight();
    }
    this.$el.prependTo('body');
    return this.$el.css({
      zIndex: 4000,
      marginLeft: (-1 * (w / 2)) + 'px',
      marginTop: (-1 * (h / 2)) + 'px',
      position: 'fixed',
      left: '50%',
      top: '50%'
    });
  }

  resizeBackdrop() {
    return this.ensureBackdrop().css({
      height: $(document).height(),
      width: $(document).width()
    });
  }

  ensureBackdrop() {
    let backdrop = $('[data-behavior=modal-backdrop]');
    if (backdrop.length === 0) {
      backdrop = $('<div class="modal-backdrop" data-behavior="modal-backdrop">').css({
        height: $(window).height()
      }).appendTo($('body')).hide();
      $(window).bind('resize', bind(this.resizeBackdrop, this));
    }
    return backdrop;
  }

  showBackdrop() {
    this.resizeBackdrop();
    return this.ensureBackdrop().fadeIn(150);
  }
}
