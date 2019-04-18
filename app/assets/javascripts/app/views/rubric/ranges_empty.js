/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import template from 'hbs!templates/rubric/ranges_empty';

export default RangesEmptyView = (function() {
  RangesEmptyView = class RangesEmptyView extends Marionette.ItemView {
    static initClass() {

      this.prototype.template = template;
      this.prototype.tagName = 'th';
      this.prototype.attributes = {
        'data-match-height-source': ''
      };
    }

    initialize(options) {}
  };
  RangesEmptyView.initClass();
  return RangesEmptyView;
})();


