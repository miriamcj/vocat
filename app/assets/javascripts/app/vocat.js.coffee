define (require) ->

  Marionette = require('marionette')
  Backbone = require('backbone')
  ModalLayoutView = require('views/modal/modal_layout')
  ModalConfirmView = require('views/modal/modal_confirm')
  DropdownView = require('views/layout/dropdown')
  FigureCollectionView = require('views/layout/figures_collection')
  ChosenView = require('views/layout/chosen')
  FileInputView = require('views/layout/file_input')
  HeaderDrawerView = require('views/layout/header_drawer')
  HeaderDrawerTriggerView = require('views/layout/header_drawer_trigger')
  NotificationLayoutView = require('views/notification/notification_layout')
  NotificationExceptionView = require('views/notification/notification_exception')

  Standalone = {
    project: require('views/course/manage/projects/project')
  }

  window.Vocat = Vocat = new Backbone.Marionette.Application()


  Vocat.routes = {
    admin: {
      'admin/courses/:course/evaluators': 'evaluatorEnrollment'
      'admin/courses/:course/assistants': 'assistantEnrollment'
      'admin/courses/:course/creators': 'creatorEnrollment'
      'admin/users/:user/courses': 'courseEnrollment'
    }
    course: {
      'courses/:course/manage/enrollment': 'creatorEnrollment'
      'courses/:course/manage/projects': 'courseManageProjects'
    }
    coursemap: {
      'courses/:course/users/evaluations': 'userCourseMap'
      'courses/:course/groups/evaluations': 'groupCourseMap'
      'courses/:course/evaluations/assets/:asset': 'assetDetail'
      'courses/:course/users/evaluations/creator/:creator': 'userCreatorDetail'
      'courses/:course/groups/evaluations/creator/:creator': 'groupCreatorDetail'
      'courses/:course/users/evaluations/project/:project': 'userProjectDetail'
      'courses/:course/groups/evaluations/project/:project': 'groupProjectDetail'
      'courses/:course/users/evaluations/creator/:creator/project/:project': 'userSubmissionDetail'
      'courses/:course/users/evaluations/creator/:creator/project/:project/asset/:asset': 'userSubmissionDetailAsset'
      'courses/:course/groups/evaluations/creator/:creator/project/:project': 'groupSubmissionDetail'
      'courses/:course/groups/evaluations/creator/:creator/project/:project/asset/:asset': 'groupSubmissionDetailAsset'
    }
    group: {
      'courses/:course/manage/groups': 'index'
    }
    page: {
      'pages/help_dev': 'helpDev'
      'pages/modal_dev': 'modalDev'
    }
    rubric: {
      'courses/:course/manage/rubrics/new': 'new'
      'admin/rubrics/new': 'new'
      'rubrics/new': 'new'
      'courses/:course/manage/rubrics/:rubric/edit': 'edit'
      'admin/rubrics/:rubric/edit': 'editWithoutCourse'
      'rubrics/:rubric/edit': 'editWithoutCourse'
    }
    submission: {
      'courses/:course/users/creator/:creator/project/:project': 'creatorProjectDetail'
      'courses/:course/groups/creator/:creator/project/:project': 'groupProjectDetail'
      'courses/:course/view/project/:project': 'creatorProjectDetail'
      'courses/:course/groups/creator/:creator': 'groupDetail'
      'courses/:course/users/creator/:creator': 'creatorDetail'
      'courses/:course/assets/:asset': 'assetDetail'
    }
  }

  Vocat.addRegions {
    main : '#region-main'
    modal : '[data-region="modal"]'
  }

  if $('[data-region="global-notifications"]').length > 0
    Vocat.addRegions {
      notification: '[data-region="global-notifications"]'
    }


  Vocat.addInitializer () ->
    # Attach views to existing dom elements
    $('[data-behavior="dropdown"]').each( (index, el) ->
      new DropdownView({el: el, vent: Vocat.vent})
    )
    $('[data-behavior="header-drawer-trigger"]').each( (index, el) ->
      new HeaderDrawerTriggerView ({el: el, vent: Vocat.vent})
    )
    $('[data-behavior="header-drawer"]').each( (index, el) ->
      new HeaderDrawerView({el: el, vent: Vocat.vent})
    )
    $('[data-behavior="chosen"]').each( (index, el) ->
      new ChosenView({el: el, vent: Vocat.vent})
    )
    $('[data-behavior="file-input"]').each( (index, el) ->
      new FileInputView({el: el, vent: Vocat.vent})
    )
    $('[data-standalone-view]').each( (index, el) ->
      viewName = $(el).data().standaloneView
      new Standalone[viewName]({el: el})
    )

  Vocat.addInitializer () ->

    # To reduce the amount of loading in development context, we load router/controller pairs dynamically.
    # TODO: Improve this for better IE support.
    pushStateEnabled = Modernizr.history
    Backbone.history.start({pushState: pushStateEnabled })
    if pushStateEnabled
      fragment = Backbone.history.getFragment()
    else
      fragment = window.location.pathname.substring(1)

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
      instantiateRouter = (Controller, controllerName) ->
        subRoutes = Vocat.routes[controllerName]
        Vocat.router = new Marionette.AppRouter({
          controller: new Controller
          appRoutes: subRoutes
        })
        Backbone.history.start({pushState: pushStateEnabled})
        if pushStateEnabled == false
          router.navigate(fragment, { trigger: true });

      switch controllerName
        when 'course' then require ['controllers/course_controller'], (CourseController) ->
          instantiateRouter(CourseController, 'course')
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

  Vocat.on('before:start', () ->

   # Setup the global notifications view
    if @.hasOwnProperty('notification')
      notification = new NotificationLayoutView({vent: Vocat.vent})
      Vocat.notification.show(notification)

    # Setup the global modal view
    modal = new ModalLayoutView(vent: @)
    Vocat.modal.show(modal)

    # Setup exception handler
    Vocat.listenTo(Vocat.vent,'exception', (reason) =>
      Vocat.main.reset()
      Vocat.vent.trigger('notification:show', new NotificationExceptionView({msg: reason}))
    )

    # Handle confirmation on data-modalconfirm elements
    $('[data-modalconfirm]').each (index, el) ->
      $el = $(el)
      $el.on('click', (e) =>
        unless $el.hasClass('modal-blocked')
          e.preventDefault()
          e.stopPropagation()
          Vocat.vent.trigger('modal:open', new ModalConfirmView({
            vent: Vocat,
            descriptionLabel: $el.attr('data-modalconfirm'),
            confirmElement: $el
            dismissEvent: 'dismiss:publish'
          }))
      )

    # Announce some key events on the global channel
    globalChannel = Backbone.Wreqr.radio.channel('global')
    $('html').bind('click', (event) ->
      globalChannel.vent.trigger('user:action', event)
    );
  )


  return Vocat

