define [
  'marionette', 'backbone', 'controllers/global_flash_controller', 'routers/portfolio_router', 'routers/coursemap_router', 'routers/submission_router', 'routers/page_router', 'views/help/placard'
], (
  Marionette, Backbone, GlobalFlashController, PortfolioRouter, CourseMapRouter, SubmissionRouter, PageRouter, HelpPlacardView
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
    Vocat.submissionRouter = new PageRouter()
    Backbone.history.start({pushState: true})


  Vocat.on('initialize:before', () ->
    helpPlacardViews = []
    $('[data-view="help-placard"]').each( (index, el) ->
      helpPlacardViews.push new HelpPlacardView({el: el})
    )
  )

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