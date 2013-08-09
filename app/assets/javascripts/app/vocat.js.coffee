define [
  'marionette', 'backbone', 'controllers/global_flash_controller', 'routers/portfolio_router', 'routers/coursemap_router', 'routers/submission_router', 'routers/page_router', 'routers/rubric_router', 'views/help/placard', 'views/modal/modal_layout'
], (
  Marionette, Backbone, GlobalFlashController, PortfolioRouter, CourseMapRouter, SubmissionRouter, PageRouter, RubricRouter, HelpPlacardView, ModalLayoutView
) ->

  window.Vocat = Vocat = new Marionette.Application()

  Vocat.addRegions {
    main : '#region-main',
    modal : '[data-region="modal"]'
    globalFlash : '#global-flash'
  }

  Vocat.addInitializer () ->
    Vocat.portfolioRouter = new PortfolioRouter()
    Vocat.courseMapRouter = new CourseMapRouter()
    Vocat.submissionRouter = new SubmissionRouter()
    Vocat.submissionRouter = new PageRouter()
    Vocat.rubricRouter = new RubricRouter()
    Backbone.history.start({pushState: true})


  Vocat.on('initialize:before', () ->
    helpPlacardViews = []
    $('[data-view="help-placard"]').each( (index, el) ->
      helpPlacardViews.push new HelpPlacardView({el: el})
    )
  )

  Vocat.on('start', () ->
    modal = new ModalLayoutView(vent: @)
    Vocat.modal.show(modal)
  )

  # Some controllers are omnipresent, not tied to a router
  globalFlashController = new GlobalFlashController
  globalFlashController.show()

  # Some global app constants that we hang on the Vocat object rather than passing them around via events.
  # Another reason for setting these thing at a very high level is that they can potentially be stored in
  # session data and need to persist across page reloads. We want these variables stored in high-level
  # location rather than in individual views.
  Vocat.glossaryEnabled = false

  return Vocat

