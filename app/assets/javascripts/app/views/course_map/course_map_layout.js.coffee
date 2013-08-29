define [
  'marionette',
  'hbs!templates/course_map/course_map_layout',
  'views/course_map/projects',
  'views/course_map/creators',
  'views/course_map/rows',
  'views/course_map/detail_creator',
  'views/course_map/detail_project',
  'views/submission/submission_layout',
  'views/course_map/header',
  'views/abstract/sliding_grid_layout',
  'views/modal/modal_error'
  'models/user',
  'models/group',
  '../../../layout/plugins'
], (Marionette, template, CourseMapProjects, CourseMapCreators, CourseMapRows, CourseMapDetailCreator, CourseMapDetailProject, CourseMapDetailCreatorProject, CourseMapHeader, SlidingGridLayout, ModalErrorView, UserModel, GroupModel) ->

  class CourseMapView extends SlidingGridLayout

    children: {}

    template: template

    sliderVisibleColumns: 4

    ui: {
      courseMapHeader: '.matrix--column-header'
      header: '[data-region="overlay-header"]'
      overlay: '[data-behavior="overlay-container"]'
      sliderLeft: '[data-behavior="matrix-slider-left"]'
      sliderRight: '[data-behavior="matrix-slider-right"]'
      groupsInput: '[data-behavior="show-groups"]'
      usersInput: '[data-behavior="show-users"]'

    }

    triggers: {
      'click [data-behavior="matrix-slider-left"]':   'slider:left'
      'click [data-behavior="matrix-slider-right"]':  'slider:right'
    }

    regions: {
      creators: '[data-region="creators"]'
      projects: '[data-region="projects"]'
      matrix: '[data-region="matrix"]'
      header: '[data-region="overlay-header"]'
      overlay: '[data-region="overlay"]'
    }

    onRender: () ->

      @sliderPosition = 0
      @updateSliderControls()

      # TODO: Consider whether this is the right spot for this.
      @header.show(@children.header)

      @bindUIElements()

      setTimeout () =>
        @ui.courseMapHeader.stickyHeader()
      , 500

    instantiateChildViews: () ->
      @children.header = new CourseMapHeader({collections: @collections, courseId: @courseId, vent: @})


    initialize: (options) ->
      @collections = options.collections
      @courseId = options.courseId

      @collections.submission.courseId = @courseId
      @collections.submission.fetch({reset: true, error: () =>
        @triggerMethod('load:error')
      , success: () =>
        @triggerMethod('load:success')
      })

      @instantiateChildViews()

      @listenTo(@overlay, 'show', () -> @onOpenOverlay())
      @listenTo(@header, 'show', () -> @onOpenHeader())

    onLoadError: () ->
      Vocat.vent.trigger('modal:open', new ModalErrorView({
        model: @model,
        vent: @,
        message: 'Unable to load course submissions.',
      }))


    showUserViews: () ->
      @creatorType = 'User'
      @creators.show(new CourseMapCreators({collection: @collections.user, courseId: @courseId, vent: @, creatorType: 'User'}))
      @projects.show(new CourseMapProjects({collection: @collections.project, courseId: @courseId, vent: @}))
      @matrix.show(new CourseMapRows({collection: @collections.user, collections: {project: @collections.project, submission: @collections.submission}, courseId: @courseId, vent: @}))
      @children.header.creatorType == 'Users'
      @sliderRecalculate()

    showGroupViews: () ->
      @creatorType = 'Group'
      @creators.show(new CourseMapCreators({collection: @collections.group, courseId: @courseId, vent: @, creatorType: 'Group'}))
      @projects.show(new CourseMapProjects({collection: @collections.project, courseId: @courseId, vent: @}))
      @matrix.show(new CourseMapRows({collection: @collections.group, collections: {project: @collections.project, submission: @collections.submission}, courseId: @courseId, vent: @}))
      @children.header.creatorType == 'Group'
      @sliderRecalculate()

    setActive: (models) ->
      @collections.user.setActive(if models.user? then models.user.id else null)
      @collections.group.setActive(if models.group? then models.group.id else null)
      @collections.project.setActive(if models.project? then models.project.id else null)

    onShowGroups: () ->
      @showGroupViews()
      @ui.groupsInput.prop('checked', true)
      @ui.usersInput.prop('checked', false)
      @triggerMethod('close:overlay')
      Vocat.courseMapRouter.navigate("courses/#{@courseId}/groups/evaluations")

    onShowUsers: () ->
      @showUserViews()
      @ui.groupsInput.prop('checked', false)
      @ui.usersInput.prop('checked', true)
      @triggerMethod('close:overlay')
      Vocat.courseMapRouter.navigate("courses/#{@courseId}/users/evaluations")

    onOpenDetailProject: (args) ->
      if @creatorType == 'User'
        @triggerMethod('open:detail:project:users', {project: args.project})
      else if @creatorType == 'Group'
        @triggerMethod('open:detail:project:groups', {project: args.project})

    onOpenDetailCreator: (args) ->
      creator = args.creator
      if creator.creatorType == 'User'
        @triggerMethod('open:detail:user', {user: creator})
      else if creator.creatorType == 'Group'
        @triggerMethod('open:detail:group', {group: creator})

    onOpenDetailUser: (args) ->
      @showUserViews()
      @setActive({user: args.user})
      Vocat.courseMapRouter.navigate("courses/#{@courseId}/users/evaluations/creator/#{args.user.id}")
      view = new CourseMapDetailCreator({
        collection: @collections.submission,
        projects: @collections.project,
        courseId: @courseId,
        vent: @,
        model: args.user
      })
      @overlay.show(view)

    onOpenDetailGroup: (args) ->
      @showGroupViews()
      @setActive({group: args.group})
      Vocat.courseMapRouter.navigate("courses/#{@courseId}/groups/evaluations/creator/#{args.group.id}")
      view = new CourseMapDetailCreator({collection: @collections.submission, creatorType: 'Group', courseId: @courseId, vent: @, model: args.group})
      @overlay.show(view)

    onOpenDetailProjectUsers: (args) ->
      @showUserViews()
      @setActive({project: args.project})
      Vocat.courseMapRouter.navigate("courses/#{@courseId}/users/evaluations/project/#{args.project.id}")
      view = new CourseMapDetailProject({collections: {creators: @collections.user,submissions: @collections.submission}, courseId: @courseId, vent: @, model: args.project})
      @overlay.show(view)

    onOpenDetailProjectGroups: (args) ->
      @showGroupViews()
      @setActive({project: args.project})
      Vocat.courseMapRouter.navigate("courses/#{@courseId}/groups/evaluations/project/#{args.project.id}")
      view = new CourseMapDetailProject({collections: {creators: @collections.group, submissions: @collections.submission}, courseId: @courseId, vent: @, model: args.project})
      @overlay.show(view)

    onOpenDetailCreatorProject: (args) ->
      if args.creator.creatorType == 'User'
        @showUserViews()
        @setActive({project: args.project, user: args.creator})
        Vocat.courseMapRouter.navigate("courses/#{@courseId}/users/evaluations/creator/#{args.creator.id}/project/#{args.project.id}")
      else if args.creator.creatorType == 'Group'
        @showGroupViews()
        @setActive({project: args.project, group: args.creator})
        Vocat.courseMapRouter.navigate("courses/#{@courseId}/groups/evaluations/creator/#{args.creator.id}/project/#{args.project.id}")

      view = new CourseMapDetailCreatorProject({
        collections: { submission: @collections.submission },
        courseId: @courseId,
        vent: @,
        creator: args.creator,
        project: args.project
      })

      @overlay.show(view)

    onRowInactive: (args) ->
      @$el.find('[data-creator="'+args.creator+'"]').removeClass('active')

    onRowActive: (args) ->
      @$el.find('[data-creator="'+args.creator+'"]').addClass('active')

    onColActive: (args) ->
      # For now, do nothing.

    onColInactive: (args) ->
      # For now, do nothing.

    scrollToHeader: (noAnimate) ->
      if noAnimate == true
        $('html, body').scrollTop(116 + 34)
      else
        $('html, body').animate({ scrollTop: 116 + 34 }, 'normal')

    scrollToTop: () ->
      $('html, body').animate({ scrollTop: 0 }, 'normal')

    onOpenOverlay: () ->
      viewportHeight = $(window).height()
      creatorsHeight = @creators.$el.outerHeight()
      minHeight = if creatorsHeight > viewportHeight then creatorsHeight else viewportHeight
      @ui.overlay.css({top: '8rem', position: 'absolute', minHeight: minHeight})
      if !@ui.overlay.is(':visible')
        @ui.overlay.fadeIn(250, () =>
          @scrollToHeader()
        )
      else
        @scrollToHeader(true)

      if !@ui.header.is(':visible')
        @ui.header.fadeIn(250)
      @$el.find('.matrix--controls a').css(visibility: 'hidden')

    onOpenHeader: () ->
      # Fade it in if not visible

    onCloseOverlay: (args) ->
      @matrix.$el.css({visibility: 'visible'})
      @setActive({})

      @$el.find('.matrix--controls a').css(visibility: 'visible')

      if @creatorType == 'Group'
        Vocat.courseMapRouter.navigate("courses/#{@courseId}/groups/evaluations")
      else if @creatorType == 'User'
        Vocat.courseMapRouter.navigate("courses/#{@courseId}/users/evaluations")

      if @ui.header.is(':visible')
        @ui.header.fadeOut 250, () =>

      if @ui.overlay.is(':visible')
        @ui.overlay.fadeOut 250, () =>
          @scrollToTop()



