/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


export default class ExpandableRange extends Marionette.Behavior {
  constructor(options) {
    super(...args);

    this.defaults = {
      childrenVisible: false
    };

    this.triggers = {
      'click @ui.toggleChild': 'toggle:child'
    };

    this.ui = {
      toggleChild: '[data-behavior="toggle-children"]',
      childContainer: '[data-behavior="child-container"]',
      range: '[data-behavior="range"]:first'
    };
  }

  onShow() {
    if (this.options.childrenVisible === false) {
      return this.ui.childContainer.hide();
    }
  }

  onToggleChild() {
    if (this.ui.childContainer.length > 0) {
      if (this.options.childrenVisible) {
        this.ui.range.removeClass('range-expandable-open');
        this.ui.childContainer.slideUp(250);
        this.view.trigger('range:closed');
      } else {
        this.ui.childContainer.slideDown(250);
        this.ui.range.addClass('range-expandable-open');
        this.view.trigger('range:open');
      }
      return this.options.childrenVisible = !this.options.childrenVisible;
    }
  }
};
