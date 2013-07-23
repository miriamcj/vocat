(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'controllers/portfolio_controller'], function(Marionette, PortfolioController) {
    var PortfolioRouter, _ref;

    return PortfolioRouter = (function(_super) {
      __extends(PortfolioRouter, _super);

      function PortfolioRouter() {
        _ref = PortfolioRouter.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      PortfolioRouter.prototype.controller = new PortfolioController;

      PortfolioRouter.prototype.appRoutes = {
        '': 'portfolio',
        'courses/:course/portfolio': 'portfolio'
      };

      return PortfolioRouter;

    })(Marionette.AppRouter);
  });

}).call(this);
