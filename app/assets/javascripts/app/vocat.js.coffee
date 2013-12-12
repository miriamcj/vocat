define (require) ->

  Marionette = require('marionette')
  Backbone = require('backbone')
  HelpPlacardView = require('views/help/placard')
  GlossaryToggleView = require('views/layout/glossary_toggle')
  GlossaryToggleView = require('views/layout/glossary_toggle')
  ModalLayoutView = require('views/modal/modal_layout')
  FlashMessagesView = require('views/flash/flash_messages')
  FlashMessagesCollection = require('collections/flash_message_collection')

  window.Vocat = Vocat = new Marionette.Application()

  Vocat.routes = {
    admin: {
      'admin/courses/:course/evaluators': 'manageEvaluators'
      'admin/courses/:course/creators': 'manageCreators'
      'admin/users/:user/courses': 'manageCourses'
    }
    coursemap: {
      'courses/:course/users/evaluations': 'userGrid'
      'courses/:course/users/evaluations/creator/:creator': 'userCreatorDetail'
      'courses/:course/users/evaluations/project/:project': 'userProjectDetail'
      'courses/:course/users/evaluations/creator/:creator/project/:project': 'userCreatorProjectDetail'
      'courses/:course/groups/evaluations': 'groupGrid'
      'courses/:course/groups/evaluations/creator/:creator': 'groupCreatorDetail'
      'courses/:course/groups/evaluations/project/:project': 'groupProjectDetail'
      'courses/:course/groups/evaluations/creator/:creator/project/:project': 'groupCreatorProjectDetail'
      'courses/:course/users/project/:project': 'standaloneUserProjectDetail'
    }
    group: {
      'courses/:course/manage/groups': 'index'
    }
    page: {
      'pages/help_dev': 'helpDev'
      'pages/modal_dev': 'modalDev'
    }
#    portfolio: {
#      'courses/:course/portfolio': 'portfolio'
#    }
    rubric: {
      'courses/:course/manage/rubrics/new': 'new'
      'rubrics/new': 'new'
      'courses/:course/manage/rubrics/:rubric/edit': 'edit'
      'rubrics/:rubric/edit': 'editWithoutCourse'
    }
    submission: {
      'courses/:course/users/creator/:creator/project/:project': 'creatorProjectDetail'
      'courses/:course/view/project/:project': 'creatorProjectDetail'
    }
  }

  Vocat.addRegions {
    main : '#region-main',
    modal : '[data-region="modal"]'
    globalFlash : '#global-flash'
  }

  Vocat.addInitializer () ->

    # To reduce the amount of loading in development context, we load router/controller pairs dynamically.
    # TODO: Make sure this works during compilation as well. We may need to do require(['string'] instead
    # TODO: of a require(variable) so that r.js picks up the dependency correctly.
    Backbone.history.start({pushState: true})
    fragment = Backbone.history.getFragment()
    Backbone.history.stop()

    regexes = {}
    controllerName = false
    router = new Backbone.Router
    _.each Vocat.routes, (subRoutes, routeKey) ->
      regexes[routeKey] = [] unless regexes[routeKey]?
      _.each subRoutes, (controllerMethod, subRoute) ->
        regex = router._routeToRegExp(subRoute)
        regexes[routeKey].push(regex)
        if fragment.match(regex)
          controllerName = routeKey

    if controllerName != false
      controllerPath = "controllers/#{controllerName}_controller"

      instantiateRouter = (Controller, controllerName) ->
        subRoutes = Vocat.routes[controllerName]
        Vocat.router = new Marionette.AppRouter({
          controller: new Controller
          appRoutes: subRoutes
        })
        Backbone.history.start({pushState: true})

      switch controllerName
        when 'admin' then require ['controllers/admin_controller'], (AdminController) ->
          instantiateRouter(AdminController, 'admin')
        when 'coursemap' then require ['controllers/coursemap_controller'], (CourseMapController) ->
          instantiateRouter(CourseMapController, 'coursemap')
        when 'group' then require ['controllers/group_controller'], (GroupController) ->
          instantiateRouter(GroupController, 'group')
        when 'page' then require ['controllers/page_controller'], (PageController) ->
          instantiateRouter(PageController, 'page')
        when 'portfolio' then require ['controllers/portfolio_controller'], (PortfolioController) ->
          instantiateRouter(PortfolioController, 'portfolio')
        when 'rubric' then require ['controllers/rubric_controller'], (RubricController) ->
          instantiateRouter(RubricController, 'rubric')
        when 'submission' then require ['controllers/submission_controller'], (SubmissionController) ->
          instantiateRouter(SubmissionController, 'submission')

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

    # Handle global flash messages
    flashMessages = new FlashMessagesCollection([], {})
    dataContainer = $("#bootstrap-globalFlash")
    if dataContainer.length > 0
      div = $('<div></div>')
      div.html dataContainer.text()
      text = div.text()
      if text? && !(/^\s*$/).test(text)
        data = JSON.parse(text)
        if data['globalFlash']? then flashMessages.reset(data['globalFlash'])

    Vocat.globalFlashView = new FlashMessagesView({vent: Vocat.vent, collection: flashMessages})
    if $(Vocat.globalFlash.el).length > 0 then Vocat.globalFlash.show(Vocat.globalFlashView)

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

  # Some global app constants that we hang on the Vocat object rather than passing them around via events.
  # Another reason for setting these thing at a very high level is that they can potentially be stored in
  # session data and need to persist across page reloads. We want these variables stored in high-level
  # location rather than in individual views.
  Vocat.glossaryEnabled = window.VocatSessionData? && window.VocatSessionData.enable_glossary? && window.VocatSessionData.enable_glossary == true

  return Vocat

