(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'controllers/vocat_controller', 'views/portfolio/portfolio', 'views/portfolio/portfolio_projects', 'views/portfolio/portfolio_submissions', 'collections/portfolio_collection', 'collections/portfolio_unsubmitted_collection'], function(Marionette, VocatController, PortfolioView, PortfolioProjectsView, PortfolioSubmissionsView, PortfolioCollection, PortfolioUnsubmittedCollection) {
    var PortfolioController, _ref;

    return PortfolioController = (function(_super) {
      __extends(PortfolioController, _super);

      function PortfolioController() {
        _ref = PortfolioController.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      PortfolioController.prototype.collections = {
        submission: new PortfolioCollection({}),
        incomplete: new PortfolioUnsubmittedCollection({})
      };

      PortfolioController.prototype.portfolio = function(courseId) {
        var incompleteFetching, portfolio, portfolioProjects, portfolioSubmissions, submissionsFetching,
          _this = this;

        if (courseId == null) {
          courseId = null;
        }
        portfolio = new PortfolioView().render();
        portfolioSubmissions = new PortfolioSubmissionsView({
          collection: this.collections.submission
        });
        portfolioProjects = new PortfolioProjectsView({
          collection: this.collections.incomplete
        });
        submissionsFetching = this.collections.submission.fetch({
          data: {
            course: courseId,
            limit: 10
          }
        });
        incompleteFetching = this.collections.incomplete.fetch({
          data: {
            course: courseId
          }
        });
        window.Vocat.main.show(portfolio);
        submissionsFetching.done(function() {
          return portfolio.submissions.show(portfolioSubmissions);
        });
        return incompleteFetching.done(function() {
          return portfolio.projects.show(portfolioProjects);
        });
      };

      return PortfolioController;

    })(VocatController);
  });

}).call(this);
