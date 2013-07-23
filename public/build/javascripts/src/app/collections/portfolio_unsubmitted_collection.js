(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'models/submission'], function(Backbone, ProjectModel) {
    var PortfolioUnsubmittedCollection, _ref;

    return PortfolioUnsubmittedCollection = (function(_super) {
      __extends(PortfolioUnsubmittedCollection, _super);

      function PortfolioUnsubmittedCollection() {
        _ref = PortfolioUnsubmittedCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      PortfolioUnsubmittedCollection.prototype.model = ProjectModel;

      PortfolioUnsubmittedCollection.prototype.url = function() {
        return "/api/v1/portfolio/unsubmitted";
      };

      return PortfolioUnsubmittedCollection;

    })(Backbone.Collection);
  });

}).call(this);
