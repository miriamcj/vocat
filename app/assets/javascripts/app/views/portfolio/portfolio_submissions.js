/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'backbone.marionette';

import PortfolioSubmissionItem from 'views/portfolio/portfolio_submissions_item';
import EmptyView from 'views/portfolio/portfolio_submissions_item_empty';

export default class PortfolioSubmissionsView extends Marionette.CollectionView {
  constructor() {

    this.childView = PortfolioSubmissionItem;
    this.emptyView = EmptyView;
  }

  onShow() {}

  onRender() {}
};
