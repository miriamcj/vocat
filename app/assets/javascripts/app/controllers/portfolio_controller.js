/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import VocatController from 'controllers/vocat_controller';
import PortfolioView from 'views/portfolio/portfolio';
import PortfolioProjectsView from 'views/portfolio/portfolio_projects';
import PortfolioSubmissionsView from 'views/portfolio/portfolio_submissions';
import SubmissionCollection from 'collections/submission_collection';
import PortfolioUnsubmittedCollection from 'collections/portfolio_unsubmitted_collection';

export default PortfolioController = (function() {
  PortfolioController = class PortfolioController extends VocatController {
    static initClass() {

      this.prototype.collections = {
        submission: new SubmissionCollection({}),
        incomplete: new PortfolioUnsubmittedCollection({})
      };
    }

    portfolio(courseId = null) {

      // The layout that contains the two lists of portfolio items
      const portfolio = new PortfolioView().render();

      // Create the two collection views
      const portfolioSubmissions = new PortfolioSubmissionsView({collection: this.collections.submission});
      const portfolioProjects = new PortfolioProjectsView({collection: this.collections.incomplete});


      this.collections.submission.courseId = courseId;
      this.collections.submission.fetch({url: this.collections.submission.url(), data: {brief: true, limit: 10}});

      // Assign the collection views to the layout; assign the layout to the main region
      window.Vocat.main.show(portfolio);
      return portfolio.submissions.show(portfolioSubmissions);
    }
  };
  PortfolioController.initClass();
  return PortfolioController;
})();

