/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import PortfolioProjectsItem from 'views/portfolio/portfolio_projects_item';
let PortfolioProjectsView;

export default PortfolioProjectsView = (function() {
  PortfolioProjectsView = class PortfolioProjectsView extends Marionette.CollectionView {
    static initClass() {

      this.prototype.childView = PortfolioProjectsItem;
    }
  };
  PortfolioProjectsView.initClass();
  return PortfolioProjectsView;
})();
