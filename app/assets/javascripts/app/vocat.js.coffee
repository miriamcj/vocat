define [
  'marionette',
  'backbone',
  'controllers/global_flash_controller',
  'routers/portfolio_router',
  'routers/coursemap_router',
  'routers/submission_router',
  'routers/page_router',
  'routers/rubric_router',
  'routers/group_router',
  'views/help/placard',
  'views/layout/glossary_toggle',
  'views/modal/modal_layout'
], (
  Marionette, Backbone, GlobalFlashController, PortfolioRouter, CourseMapRouter, SubmissionRouter, PageRouter, RubricRouter, GroupRouter, HelpPlacardView, GlossaryToggleView, ModalLayoutView
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
    Vocat.groupRouter = new GroupRouter()
    Backbone.history.start({pushState: true})


  Vocat.on('initialize:before', () ->

    modal = new ModalLayoutView(vent: @)
    Vocat.modal.show(modal)

    helpPlacardViews = []
    $('[data-view="help-placard"]').each( (index, el) ->
      helpPlacardViews.push new HelpPlacardView({el: el})
    )

    $('[data-view="glossary-toggle"]').each( (index, el) ->
      new GlossaryToggleView({el: el})
    )

  )

  Vocat.on('glossary:enabled:toggle', () =>
    if Vocat.glossaryEnabled == true
      Vocat.glossaryEnabled = false
      Vocat.trigger('glossary:enabled:updated')
      $.ajax('/users/settings', {
        type: 'PUT'
        dataType: 'json'
        data: {user: {settings: {enable_glossary: false}}}
      })
    else
      Vocat.glossaryEnabled = true
      Vocat.trigger('glossary:enabled:updated')
      $.ajax('/users/settings', {
        type: 'PUT'
        dataType: 'json'
        data: {user: {settings: {enable_glossary: true}}}
      })

  )

  # Some controllers are omnipresent, not tied to a router
  globalFlashController = new GlobalFlashController
  globalFlashController.show()

  # Some global app constants that we hang on the Vocat object rather than passing them around via events.
  # Another reason for setting these thing at a very high level is that they can potentially be stored in
  # session data and need to persist across page reloads. We want these variables stored in high-level
  # location rather than in individual views.
  Vocat.glossaryEnabled = window.VocatSessionData? && window.VocatSessionData.enable_glossary? && window.VocatSessionData.enable_glossary == true



  return Vocat

