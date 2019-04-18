/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import template from 'hbs!templates/portfolio/portfolio_item_empty';
let PortfolioItemEmptyView;

export default PortfolioItemEmptyView = (function() {
  PortfolioItemEmptyView = class PortfolioItemEmptyView extends Marionette.ItemView {
    static initClass() {

      this.prototype.template = template;
    }
  };
  PortfolioItemEmptyView.initClass();
  return PortfolioItemEmptyView;
})();
