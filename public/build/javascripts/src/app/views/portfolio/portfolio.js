(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/portfolio/portfolio'], function(Marionette, Template) {
    var PortfolioView, _ref;

    return PortfolioView = (function(_super) {
      __extends(PortfolioView, _super);

      function PortfolioView() {
        _ref = PortfolioView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      PortfolioView.prototype.template = Template;

      PortfolioView.prototype.regions = {
        submissions: '[data-region="submissions"]',
        projects: '[data-region="projects"]'
      };

      return PortfolioView;

    })(Marionette.Layout);
  });

}).call(this);
