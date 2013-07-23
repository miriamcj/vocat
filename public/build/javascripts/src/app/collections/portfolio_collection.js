(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'models/submission'], function(Backbone, SubmissionModel) {
    var PortfolioCollection, _ref;

    return PortfolioCollection = (function(_super) {
      __extends(PortfolioCollection, _super);

      function PortfolioCollection() {
        _ref = PortfolioCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      PortfolioCollection.prototype.model = SubmissionModel;

      PortfolioCollection.prototype.url = function() {
        return "/api/v1/portfolio";
      };

      return PortfolioCollection;

    })(Backbone.Collection);
  });

}).call(this);
