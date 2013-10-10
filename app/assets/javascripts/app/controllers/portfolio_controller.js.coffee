define [
  'marionette', 'controllers/vocat_controller', 'views/portfolio/portfolio', 'views/portfolio/portfolio_projects', 'views/portfolio/portfolio_submissions', 'collections/submission_collection', 'collections/portfolio_unsubmitted_collection'
], (
  Marionette, VocatController, PortfolioView, PortfolioProjectsView, PortfolioSubmissionsView, SubmissionCollection, PortfolioUnsubmittedCollection
) ->

  class PortfolioController extends VocatController

    collections: {
      submission: new SubmissionCollection({})
      incomplete: new PortfolioUnsubmittedCollection({})
    }

    portfolio: (courseId = null) ->

      # The layout that contains the two lists of portfolio items
      portfolio = new PortfolioView().render()

      # Create the two collection views
      portfolioSubmissions = new PortfolioSubmissionsView({collection: @collections.submission})
      portfolioProjects = new PortfolioProjectsView({collection: @collections.incomplete})


      @collections.submission.courseId = courseId
      @collections.submission.fetch({url: @collections.submission.url(), data: {brief: true, limit: 10}})

      # Assign the collection views to the layout; assign the layout to the main region
      window.Vocat.main.show(portfolio)
      portfolio.submissions.show(portfolioSubmissions)

