(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'views/portfolio/portfolio_projects_item'], function(Marionette, PortfolioProjectsItem) {
    var PortfolioProjectsView, _ref;

    return PortfolioProjectsView = (function(_super) {
      __extends(PortfolioProjectsView, _super);

      function PortfolioProjectsView() {
        _ref = PortfolioProjectsView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      PortfolioProjectsView.prototype.itemView = PortfolioProjectsItem;

      return PortfolioProjectsView;

    })(Marionette.CollectionView);
  });

}).call(this);
