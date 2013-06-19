define ['marionette', 'backbone', 'routers/portfolio_router', 'routers/coursemap_router'], (Marionette, Backbone, PortfolioRouter, CourseMapRouter) ->

  window.Vocat = Vocat = new Marionette.Application()

  Vocat.addRegions {
    main : '#region-main',
  }

  Vocat.addInitializer () ->
    portfolioRouter = new PortfolioRouter()
    courseMapRouter = new CourseMapRouter()
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