define [
  'marionette', 'backbone', 'controllers/global_flash_controller', 'routers/portfolio_router', 'routers/coursemap_router', 'routers/submission_router'
], (
  Marionette, Backbone, GlobalFlashController, PortfolioRouter, CourseMapRouter, SubmissionRouter
) ->

  window.Vocat = Vocat = new Marionette.Application()

  Vocat.addRegions {
    main : '#region-main',
    globalFlash : '#global-flash'
  }

  Vocat.addInitializer () ->
    Vocat.portfolioRouter = new PortfolioRouter()
    Vocat.courseMapRouter = new CourseMapRouter()
    Vocat.submissionRouter = new SubmissionRouter()
    Backbone.history.start({pushState: true})

  # Some controllers are omnipresent, not tied to a router
  globalFlashController = new GlobalFlashController
  globalFlashController.show()

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