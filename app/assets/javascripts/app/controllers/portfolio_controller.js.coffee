define [
  'marionette', 'controllers/vocat_controller', 'views/portfolio/portfolio', 'views/portfolio/portfolio_projects', 'views/portfolio/portfolio_submissions', 'collections/submission_collection', 'collections/project_collection'
], (
  Marionette, VocatController, PortfolioView, PortfolioProjectsView, PortfolioSubmissionsView, SubmissionCollection, ProjectCollection
) ->

  class PortfolioController extends VocatController

    collections: {
      submission: new SubmissionCollection({})
      project: new ProjectCollection({})
    }

    portfolio: (course = null) ->

      # The layout that contains the two lists of portfolio items
      portfolio = new PortfolioView().render()

      # Create the two collection views
      portfolioSubmissions = new PortfolioSubmissionsView({collection: @collections.submission})
      portfolioProjects = new PortfolioProjectsView({collection: @collections.project})

      @collections.submission.fetch()
      console.log course

      # Assign the collection views to the layout; assign the layout to the main region
      window.Vocat.main.show(portfolio)
      portfolio.submissions.show(portfolioSubmissions)
      portfolio.projects.show(portfolioProjects)

