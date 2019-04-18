/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import Template from 'hbs!templates/portfolio/portfolio';
let PortfolioView;

export default PortfolioView = (function() {
  PortfolioView = class PortfolioView extends Marionette.LayoutView {
    static initClass() {

      this.prototype.template = Template;

      this.prototype.regions = {
        submissions: '[data-region="submissions"]',
        projects: '[data-region="projects"]'
      };
    }
  };
  PortfolioView.initClass();
  return PortfolioView;
})();

