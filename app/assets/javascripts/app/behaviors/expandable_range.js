/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let ExpandableRange;
const Marionette = require('marionette');

export default ExpandableRange = (function() {
  ExpandableRange = class ExpandableRange extends Marionette.Behavior {
    static initClass() {

      this.prototype.defaults = {
        childrenVisible: false
      };

      this.prototype.triggers = {
        'click @ui.toggleChild': 'toggle:child'
      };

      this.prototype.ui = {
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
  ExpandableRange.initClass();
  return ExpandableRange;
})();
