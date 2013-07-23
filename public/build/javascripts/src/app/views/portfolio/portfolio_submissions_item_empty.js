(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/portfolio/portfolio_item_empty'], function(Marionette, template) {
    var PortfolioItemEmptyView, _ref;

    return PortfolioItemEmptyView = (function(_super) {
      __extends(PortfolioItemEmptyView, _super);

      function PortfolioItemEmptyView() {
        _ref = PortfolioItemEmptyView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      PortfolioItemEmptyView.prototype.template = template;

      return PortfolioItemEmptyView;

    })(Marionette.ItemView);
  });

}).call(this);
