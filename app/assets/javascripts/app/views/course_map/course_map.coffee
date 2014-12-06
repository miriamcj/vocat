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
  GroupSubmissionCollection = require('collections/submission_for_group_collection')
  AssetShowLayout = require('views/assets/asset_show_layout')

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
      viewToggle: '[data-behavior="view-toggle"]'
      hideOnWarning: '[data-behavior="hide-on-warning"]'
    }

    triggers: {
      'click [data-behavior="matrix-slider-left"]':   'slider:left'
      'click [data-behavior="matrix-slider-right"]':  'slider:right'
      'change @ui.viewToggle': {
        event: 'view:toggle'
        preventDefault: false
        stopPropagation: false
      }
    }

    regions: {
      creators: '[data-region="creators"]'
      projects: '[data-region="projects"]'
      matrix: '[data-region="matrix"]'
      globalFlash: '[data-region="flash"]'
      warning: '[data-region="warning"]'
    }

    onRender: () ->

    setupListeners: () ->
      @listenTo(@, 'redraw', () ->
        @adjustToCurrentPosition()
      )
      @listenTo(@, 'navigate:submission', (args) ->
        @navigateToSubmission(args.submission)
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

    navigateToSubmission: (submissionId) ->
      model = @collections.submission.get(submissionId)
      if model?
        type = model.get('creator_type')
        if type == 'User'
          url_base = "courses/#{@courseId}/users/"
        else if type == 'Group'
          url_base = "courses/#{@courseId}/groups/"
        if url_base?
          url = url_base + "evaluations/creator/#{model.get('creator_id')}/project/#{model.get('project_id')}"
          Vocat.router.navigate(url, true)

    navigateToCreator: (creatorId) ->
      if @creatorType == 'User'
        Vocat.router.navigate("courses/#{@courseId}/users/evaluations/creator/#{creatorId}", true)
      else if @creatorType == 'Group'
        Vocat.router.navigate("courses/#{@courseId}/groups/evaluations/creator/#{creatorId}", true)

    typeProxiedProjectCollection: () ->
      projectType = "#{@creatorType}Project"
      proxiedCollection = CollectionProxy(@collections.project)
      proxiedCollection.where((model) -> model.get('type') == projectType || model.get('type') == 'OpenProject')
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
      @showChildViews()

    createChildViews: () ->
      @creatorsView = new CourseMapCreators({collection: @creatorCollection, courseId: @courseId, vent: @, creatorType: @creatorType})
      @projectsView = new CourseMapProjects({collection: @projectCollection, courseId: @courseId, vent: @})
      @matrixView = new CourseMapMatrix({collection: @creatorCollection, collections: {project: @projectCollection, submission: @collections.submission}, courseId: @courseId, creatorType: @creatorType, vent: @})

    initialize: (options) ->
      @collections = Marionette.getOption(@, 'collections')
      @courseId = Marionette.getOption(@, 'courseId')
      @creatorType = Marionette.getOption(@, 'creatorType')
      @projectCollection = @typeProxiedProjectCollection()
      @creatorCollection = @typeProxiedCreatorCollection()
      @createChildViews()
      @setupListeners()

    onViewToggle: () ->
      val = @$el.find('[data-behavior="view-toggle"]:checked').val()
      if val == 'individuals'
        Vocat.router.navigate("courses/#{@courseId}/users/evaluations", true)
      else if val == 'groups'
        Vocat.router.navigate("courses/#{@courseId}/groups/evaluations", true)

    serializeData: () ->
      out = {
        creatorType: @creatorType
      }
      out

#      showUserViews: () ->
#        currentCreatorType = @creatorType
#        @creatorType = 'User'
#        userProjectsCollection = CollectionProxy(@collections.project)
#        userProjectsCollection.where((model) -> model.get('type') == 'UserProject' || model.get('type') == 'OpenProject')
#
#        if userProjectsCollection.length == 0
#          return @showEmptyWarning('User', 'Project')
#
#        if @collections.user.length == 0
#          return @showEmptyWarning('User', 'Creator')
#
#        if @warning?
#          @warning.reset()
#
#        if currentCreatorType != 'User'
#          @creators.show(new CourseMapCreators({collection: @collections.user, courseId: @courseId, vent: @, creatorType: 'User'}))
#          @projects.show(new CourseMapProjects({collection: userProjectsCollection, courseId: @courseId, vent: @}))
#          @matrix.show(new CourseMapMatrix({collection: @collections.user, collections: {project: userProjectsCollection, submission: @collections.submission}, courseId: @courseId, creatorType: 'User', vent: @}))
#          @recalculateMatrix()
#
#      showGroupViews: () ->
#        currentCreatorType = @creatorType
#        @creatorType = 'Group'
#        groupProjectsCollection = CollectionProxy(@collections.project)
#        groupProjectsCollection.where((model) -> model.get('type') == 'GroupProject' || model.get('type') == 'OpenProject')
#
#        if groupProjectsCollection.length == 0
#          return @showEmptyWarning('Group', 'Project')
#
#        if @collections.group.length == 0
#          return @showEmptyWarning('Group', 'Creator')
#
#        @warning.reset()
#        if currentCreatorType != 'Group'
#          @creators.show(new CourseMapCreators({collection: @collections.group, courseId: @courseId, vent: @, creatorType: 'Group'}))
#          @projects.show(new CourseMapProjects({collection: groupProjectsCollection, courseId: @courseId, vent: @}))
#          @matrix.show(new CourseMapMatrix({collection: @collections.group, collections: {project: groupProjectsCollection, submission: @collections.submission}, courseId: @courseId, creatorType: 'Group', vent: @}))
#          @recalculateMatrix()
#
#      showEmptyWarning: (creatorType, warningType) ->
#        @warning.show(new WarningView({creatorType: creatorType, warningType: warningType, courseId: @courseId}))
#        @ui.hideOnWarning.hide()
#
#      onShowGroups: () ->
#        @showGroupViews()
#        @$el.find('#view-individuals').prop('checked', false)
#        @$el.find('#view-groups').prop('checked', true)
#        Vocat.router.navigate("courses/#{@courseId}/groups/evaluations")
#
#      onShowUsers: () ->
#        @showUserViews()
#        @$el.find('#view-individuals').prop('checked', true)
#        @$el.find('#view-groups').prop('checked', false)
#        Vocat.router.navigate("courses/#{@courseId}/users/evaluations")
#
#      onViewToggle: () ->
#        val = @$el.find('[data-behavior="view-toggle"]:checked').val()
#        if val == 'individuals'
#          @triggerMethod('show:users')
#        else if val == 'groups'
#          @triggerMethod('show:groups')
#
#      onOpenDetailProject: (args) ->
#        if @creatorType == 'User'
#          @triggerMethod('open:detail:project:users', {project: args.project})
#        else if @creatorType == 'Group'
#          @triggerMethod('open:detail:project:groups', {project: args.project})
#
#      onOpenDetailCreator: (args) ->
#        creator = args.creator
#        if creator.creatorType == 'User'
#          @triggerMethod('open:detail:user', {user: creator})
#        else if creator.creatorType == 'Group'
#          @triggerMethod('open:detail:group', {group: creator})
#
#      onOpenDetailUser: (args) ->
#        @showUserViews()
#        Vocat.router.navigate("courses/#{@courseId}/users/evaluations/creator/#{args.user.id}")
#        view = new CourseMapDetailCreator({
#          collection: new CourseUserSubmissionCollection(),
#          courseId: @courseId,
#          vent: @,
#          model: args.user
#        })
#        @openDetail(view)
#
#      onOpenDetailGroup: (args) ->
#        @showGroupViews()
#        Vocat.router.navigate("courses/#{@courseId}/groups/evaluations/creator/#{args.group.id}")
#        view = new CourseMapDetailCreator({
#          collection: new GroupSubmissionCollection(),
#          courseId: @courseId,
#          vent: @,
#          model: args.group
#        })
#        @openDetail(view)
#
#      onOpenDetailProjectUsers: (args) ->
#        @showUserViews()
#        Vocat.router.navigate("courses/#{@courseId}/users/evaluations/project/#{args.project.id}")
#        view = new CourseMapDetailProject({collections: {creators: @collections.user,submissions: @collections.submission}, courseId: @courseId, vent: @, model: args.project})
#        @openDetail(view)
#
#      onOpenDetailProjectGroups: (args) ->
#        @showGroupViews()
#        Vocat.router.navigate("courses/#{@courseId}/groups/evaluations/project/#{args.project.id}")
#        view = new CourseMapDetailProject({collections: {creators: @collections.group, submissions: @collections.submission}, courseId: @courseId, vent: @, model: args.project})
#        @openDetail(view)
#
#      onOpenDetailAsset: (asset) ->
#        view = new AssetShowLayout({model: asset, vent: @})
#        Vocat.router.navigate("courses/#{@courseId}/evaluations/assets/#{asset.id}")
#        @openDetail(view)
#
#      onOpenDetailSubmission: (submission) ->
#        if !_.isObject(submission)
#          submission = @collections.submission.get(submission)
#        type = submission.get('creator_type')
#        creatorId = submission.get('creator_id')
#        projectId = submission.get('project_id')
#        if type == 'User'
#          @onOpenDetailCreator
#
#      onOpenDetailCreatorProject: (args) ->
#        if !_.isObject(args.project)
#          args.project = @collections.project.get(args.project)
#
#        if args.creator.creatorType == 'User'
#          @showUserViews()
#          Vocat.router.navigate("courses/#{@courseId}/users/evaluations/creator/#{args.creator.id}/project/#{args.project.id}")
#        else if args.creator.creatorType == 'Group'
#          @showGroupViews()
#          Vocat.router.navigate("courses/#{@courseId}/groups/evaluations/creator/#{args.creator.id}/project/#{args.project.id}")
#        submission = @collections.submission.findWhere({creator_id: args.creator.id, project_id: args.project.id, creator_type: args.creator.creatorType})
#        view = new CourseMapDetailCreatorProject({
#          collections: { submission: @collections.submission },
#          courseId: @courseId,
#          vent: @,
#          creator: args.creator,
#          project: args.project
#          model: submission
#        })
#        @openDetail(view)
#
#      openDetail: (view) ->
#        @ui.detail.show()
#        @detail.show(view)
#        @captureScroll()
#        window.scrollTo(0,0);

#      captureScroll: () ->
#        @capturedScroll = $(window).scrollTop()
#
#      restoreScroll: () ->
#        if @capturedScroll
#          $(window).scrollTop(@capturedScroll)
#          setTimeout(() =>
#            $(window).scrollTop(@capturedScroll)
#          , 100)
#
#      onCloseDetail: (args) ->
#        @ui.detail.hide()
#        @detail.empty()
#        if @creatorType == 'Group'
#          Vocat.router.navigate("courses/#{@courseId}/groups/evaluations")
#        else if @creatorType == 'User'
#          Vocat.router.navigate("courses/#{@courseId}/users/evaluations")
#        @recalculateMatrix()
#        @restoreScroll()
#
#      onEvaluationsPublish: (project) ->
#        endpoint = "#{project.url()}/publish_evaluations"
#        $.ajax(endpoint, {
#          type: 'put'
#          dataType: 'json'
#          data: {}
#          success: (data, textStatus, jqXHR) =>
#            Vocat.vent.trigger('error:add', {level: 'notice', lifetime: 4000, msg: "Your evaluations for #{project.get('name')} submissions have been published"})
#            submissions = @collections.submission.where({project_id: project.id})
#            _.each(submissions, (submission) ->
#              submission.set('current_user_published', true)
#            )
#          error: (jqXHR, textStatus, error) =>
#            Vocat.vent.trigger('error:add', {level: 'notice', lifetime: 4000, msg: "Unable to publish submissions."})
#        })
#
#      onEvaluationsUnpublish: (project) ->
#        endpoint = "#{project.url()}/unpublish_evaluations"
#        $.ajax(endpoint, {
#          type: 'put'
#          dataType: 'json'
#          data: {}
#          success: (data, textStatus, jqXHR) =>
#            Vocat.vent.trigger('error:add', {level: 'notice', lifetime: 4000, msg: "Your evaluations for #{project.get('name')} submissions have been unpublished"})
#            submissions = @collections.submission.where({project_id: project.id})
#            _.each(submissions, (submission) ->
#              submission.set('current_user_published', false)
#            )
#          error: (jqXHR, textStatus, error) =>
#            Vocat.vent.trigger('error:add', {level: 'notice', lifetime: 4000, msg: "Unable to unpublish submissions."})
#        })

#      onColActive: (args) ->
#        # For now, do nothing.
#
#      onColInactive: (args) ->
#        # For now, do nothing.
#
