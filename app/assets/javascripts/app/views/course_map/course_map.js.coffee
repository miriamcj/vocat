define (require) ->
  template = require('hbs!templates/course_map/course_map_layout')
  Backbone = require('backbone')
  CollectionProxy = require('collections/collection_proxy')
  CourseMapProjects = require('views/course_map/projects')
  CourseMapCreators = require('views/course_map/creators')
  CourseMapMatrix = require('views/course_map/matrix')
  CourseMapDetailCreator = require('views/course_map/detail_creator')
  WarningView = require('views/course_map/warning')
  AbstractMatrix = require('views/abstract/abstract_matrix')

  class CourseMapLayout extends AbstractMatrix

    children: {}
    minWidth: 170
    capturedScroll: 0
    stickyHeader: true
    template: template
    creatorType: 'User'
    projectsView: null
    creatorsView: null
    matrixView: null

    ui: {
      detail: '[data-region="detail"]'
      sliderLeft: '[data-behavior="matrix-slider-left"]'
      sliderRight: '[data-behavior="matrix-slider-right"]'
      hideOnWarning: '[data-behavior="hide-on-warning"]'
    }

    triggers: {
      'click [data-behavior="matrix-slider-left"]': 'slider:left'
      'click [data-behavior="matrix-slider-right"]': 'slider:right'
    }

    regions: {
      creators: '[data-region="creators"]'
      projects: '[data-region="projects"]'
      matrix: '[data-region="matrix"]'
      globalFlash: '[data-region="flash"]'
      warning: '[data-region="warning"]'
    }

    setupListeners: () ->
      @listenTo(@, 'redraw', () ->
        @adjustToCurrentPosition()
      )
      @listenTo(@, 'navigate:submission', (args) ->
        @navigateToSubmission(args.project, args.creator)
      )
      @listenTo(@, 'navigate:creator', (args) ->
        @navigateToCreator(args.creator)
      )
      @listenTo(@, 'navigate:project', (args) ->
        @navigateToProject(args.project)
      )

    navigateToProject: (projectId) ->
      if @creatorType == 'User'
        Vocat.router.navigate("courses/#{@courseId}/users/evaluations/project/#{projectId}", true)
      else if @creatorType == 'Group'
        Vocat.router.navigate("courses/#{@courseId}/groups/evaluations/project/#{projectId}", true)

    navigateToSubmission: (projectId, creatorId) ->
      typeSegment = "#{@creatorType.toLowerCase()}s"
      url = "courses/#{@courseId}/#{typeSegment}/evaluations/creator/#{creatorId}/project/#{projectId}"
      Vocat.router.navigate(url, true)

    navigateToCreator: (creatorId) ->
      if @creatorType == 'User'
        Vocat.router.navigate("courses/#{@courseId}/users/evaluations/creator/#{creatorId}", true)
      else if @creatorType == 'Group'
        Vocat.router.navigate("courses/#{@courseId}/groups/evaluations/creator/#{creatorId}", true)

    typeProxiedProjectCollection: () ->
      projectType = "#{@creatorType}Project"
      proxiedCollection = CollectionProxy(@collections.project)
      proxiedCollection.where((model) ->
        abilities = model.get('abilities')
        abilities.can_show_submissions == true && (model.get('type') == projectType || model.get('type') == 'OpenProject')
      )
      proxiedCollection

    typeProxiedCreatorCollection: () ->
      if @creatorType == 'User'
        @collections.user
      else if @creatorType == 'Group'
        @collections.group
      else
        new Backbone.Collection

    showChildViews: () ->
      @creators.show(@creatorsView)
      @projects.show(@projectsView)
      @matrix.show(@matrixView)
      @sliderPosition = 0
      @parentOnShow()
      @bindUIElements()

    onShow: () ->
      if @projectCollection.length == 0
        @showEmptyWarning(@creatorType, 'Project')
      else if @creatorCollection.length == 0
        @showEmptyWarning(@creatorType, 'Creator')
      else
        @createChildViews()
        @setupListeners()
        @showChildViews()

    createChildViews: () ->
      @creatorsView = new CourseMapCreators({
        collection: @creatorCollection,
        courseId: @courseId,
        vent: @,
        creatorType: @creatorType
      })
      @projectsView = new CourseMapProjects({collection: @projectCollection, courseId: @courseId, vent: @})
      @matrixView = new CourseMapMatrix({
        collection: @creatorCollection,
        collections: {project: @projectCollection, submission: @collections.submission},
        courseId: @courseId,
        creatorType: @creatorType,
        vent: @
      })

    initialize: (options) ->
      @collections = Marionette.getOption(@, 'collections')
      @courseId = Marionette.getOption(@, 'courseId')
      @creatorType = Marionette.getOption(@, 'creatorType')
      @projectCollection = @typeProxiedProjectCollection()
      @creatorCollection = @typeProxiedCreatorCollection()
      @collections.submission.fetch(reset: true, data: {course: @courseId} )

    showEmptyWarning: (creatorType, warningType) ->
      @warning.show(new WarningView({creatorType: creatorType, warningType: warningType, courseId: @courseId}))
      @ui.hideOnWarning.hide()

    onEvaluationsPublish: (project) ->
      endpoint = "#{project.url()}/publish_evaluations"
      $.ajax(endpoint, {
        type: 'put'
        dataType: 'json'
        data: {}
        success: (data, textStatus, jqXHR) =>
          Vocat.vent.trigger('error:add', {
            level: 'notice',
            lifetime: 4000,
            msg: "Your evaluations for #{project.get('name')} submissions have been published"
          })
          submissions = @collections.submission.where({project_id: project.id})
          _.each(submissions, (submission) ->
            submission.set('current_user_published', true)
          )
        error: (jqXHR, textStatus, error) =>
          Vocat.vent.trigger('error:add', {level: 'notice', lifetime: 4000, msg: "Unable to publish submissions."})
      })

    onEvaluationsUnpublish: (project) ->
      endpoint = "#{project.url()}/unpublish_evaluations"
      $.ajax(endpoint, {
        type: 'put'
        dataType: 'json'
        data: {}
        success: (data, textStatus, jqXHR) =>
          Vocat.vent.trigger('error:add', {
            level: 'notice',
            lifetime: 4000,
            msg: "Your evaluations for #{project.get('name')} submissions have been unpublished"
          })
          submissions = @collections.submission.where({project_id: project.id})
          _.each(submissions, (submission) ->
            submission.set('current_user_published', false)
          )
        error: (jqXHR, textStatus, error) =>
          Vocat.vent.trigger('error:add', {level: 'notice', lifetime: 4000, msg: "Unable to unpublish submissions."})
      })

    serializeData: () ->
      out = {
        creatorType: @creatorType
        hasGroupProjects: @collections.project.hasGroupProjects()
        hasUserProjects: @collections.project.hasUserProjects()
      }
      out
