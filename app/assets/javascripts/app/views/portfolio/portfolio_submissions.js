/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import PortfolioSubmissionItem from 'views/portfolio/portfolio_submissions_item';
import EmptyView from 'views/portfolio/portfolio_submissions_item_empty';
let PortfolioSubmissionsView;

export default PortfolioSubmissionsView = (function() {
  PortfolioSubmissionsView = class PortfolioSubmissionsView extends Marionette.CollectionView {
    static initClass() {

      this.prototype.childView = PortfolioSubmissionItem;
      this.prototype.emptyView = EmptyView;
    }

    onShow() {}

    onRender() {}
  };
  PortfolioSubmissionsView.initClass();
  return PortfolioSubmissionsView;
})();
