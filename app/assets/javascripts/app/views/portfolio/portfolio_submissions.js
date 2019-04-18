/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['marionette', 'views/portfolio/portfolio_submissions_item',
        'views/portfolio/portfolio_submissions_item_empty'], function(Marionette, PortfolioSubmissionItem, EmptyView) {
  let PortfolioSubmissionsView;
  return PortfolioSubmissionsView = (function() {
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
});
