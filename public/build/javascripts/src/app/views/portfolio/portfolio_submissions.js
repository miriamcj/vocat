(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'views/portfolio/portfolio_submissions_item', 'views/portfolio/portfolio_submissions_item_empty'], function(Marionette, PortfolioSubmissionItem, EmptyView) {
    var PortfolioSubmissionsView, _ref;

    return PortfolioSubmissionsView = (function(_super) {
      __extends(PortfolioSubmissionsView, _super);

      function PortfolioSubmissionsView() {
        _ref = PortfolioSubmissionsView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      PortfolioSubmissionsView.prototype.itemView = PortfolioSubmissionItem;

      PortfolioSubmissionsView.prototype.emptyView = EmptyView;

      return PortfolioSubmissionsView;

    })(Marionette.CollectionView);
  });

}).call(this);
