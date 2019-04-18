/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import ClosesOnUserAction from 'behaviors/closes_on_user_action';

export default class DropdownView extends Marionette.ItemView {
  static initClass() {

    this.prototype.adjusted = false;
    this.prototype.allowAdjustment = true;
    this.prototype.originalBodyPadding = null;


    this.prototype.triggers = {
      'click @ui.trigger': 'click:trigger'
    };

    this.prototype.ui = {
      trigger: '[data-behavior="toggle"]',
      dropdown: '[data-behavior="dropdown-options"]'
    };

    this.prototype.behaviors = {
      closesOnUserAction: {
        behaviorClass: ClosesOnUserAction
      }
    };
  }

  onClickTrigger() {
    if (this.$el.hasClass('open')) {
      return this.close();
    } else {
      return this.open();
    }
  }

  adjustPosition() {
    const dd = this.$el.find('[data-behavior="dropdown-options"]');
    if ((this.adjusted === false) && (this.getOption('allowAdjustment') === true)) {
      if (dd.offset().left < 0) {
        dd.css({left: 0});
        dd.css({right: 'auto'});
      } else if (((dd.width() + dd.offset().left) - $('html').width()) < 25) {
        dd.css({right: 0});
        dd.css({left: 'auto'});
      }
      return this.adjusted = true;
    }
  }

  checkBodyPadding() {
    const dd = this.$el.find('[data-behavior="dropdown-options"]');
    const height = dd.outerHeight();
    const requiredHeight = this.$el.offset().top + height + this.$el.outerHeight();
    const documentHeight = $(document).height();
    if (requiredHeight > documentHeight) {
      this.originalBodyPadding = parseInt($('body').css('padding-bottom').replace('px',''));
      const newPadding = (parseInt(requiredHeight) - parseInt(documentHeight)) + this.originalBodyPadding + 60;
      return $('body').css({paddingBottom: newPadding});
    }
  }

  restoreBodyPadding() {
    if (this.originalBodyPadding !== null) {
      $('body').css({paddingBottom: this.originalBodyPadding});
      return this.originalBodyPadding = null;
    }
  }

  open() {
    this.checkBodyPadding();
    this.$el.addClass('open');
    this.adjustPosition();
    return this.triggerMethod('opened');
  }

  close() {
    this.$el.removeClass('open');
    this.triggerMethod('closed');
    return this.restoreBodyPadding();
  }

  initialize(options) {
    this.vent = options.vent;
    this.$dropdown = this.$el.find(this.ui.dropdown);
    this.$trigger = this.$el.find(this.ui.trigger);

    if (!this.$el.hasClass('dropdown-initialized')) {
      return this.$el.addClass('dropdown-initialized');
    }
  }
};
