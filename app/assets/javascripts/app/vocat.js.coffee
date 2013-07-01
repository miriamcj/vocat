define ['marionette', 'backbone', 'routers/portfolio_router', 'routers/coursemap_router', 'routers/submission_router'], (Marionette, Backbone, PortfolioRouter, CourseMapRouter, SubmissionRouter) ->

  window.Vocat = Vocat = new Marionette.Application()

  Vocat.addRegions {
    main : '#region-main',
  }

  Vocat.addInitializer () ->
    Vocat.portfolioRouter = new PortfolioRouter()
    Vocat.courseMapRouter = new CourseMapRouter()
    Vocat.submissionRouter = new SubmissionRouter()
    Backbone.history.start({pushState: true})

  return Vocat


#window.Vocat = {
#  Bootstrap: {
#    Views: {}
#    Collections: {}
#    Models: {}
#  }
#  Instantiated: {
#    Views: {}
#    Collections: {}
#  }
#  Models: {}
#  Collections: {}
#  Routers: {}
#  Views: {}
#  Routes: window.Routes # Pick up the JS-Routes object from the global variable for convenience.
#}