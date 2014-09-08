define [
  'marionette',
  'hbs!templates/course_map/course_map_layout',
  'collections/collection_proxy',
  'views/course_map/projects',
  'views/course_map/creators',
  'views/course_map/matrix',
  'views/course_map/detail_creator',
  'views/project/detail',
  'views/submission/submission_layout',
  'views/course_map/header',
  'views/abstract/sliding_grid_layout',
  'views/modal/modal_error'
  'models/user',
  'models/group',
  '../../../layout/plugins'
], (Marionette, template, CollectionProxy, CourseMapProjects, CourseMapCreators, CourseMapMatrix, CourseMapDetailCreator, CourseMapDetailProject, CourseMapDetailCreatorProject, CourseMapHeader, SlidingGridLayout, ModalErrorView, UserModel, GroupModel) ->

  class CourseMapView extends SlidingGridLayout

    children: {}

    template: template


    ui: {
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
      globalFlash: '[data-region="flash"]'
    }

    onRender: () ->
      @globalFlash.show(Vocat.globalFlashView)
      @sliderPosition = 0
      @updateSliderControls()
      @bindUIElements()

    initialize: (options) ->
      @collections = options.collections
      @courseId = options.courseId

    showUserViews: () ->
      @creatorType = 'User'
      userProjectsCollection = CollectionProxy(@collections.project)
      userProjectsCollection.where((model) -> model.get('type') == 'UserProject' || model.get('type') == 'OpenProject')

      @creators.show(new CourseMapCreators({collection: @collections.user, courseId: @courseId, vent: @, creatorType: 'User'}))
      @projects.show(new CourseMapProjects({collection: userProjectsCollection, courseId: @courseId, vent: @}))
      @matrix.show(new CourseMapMatrix({collection: @collections.user, collections: {project: userProjectsCollection, submission: @collections.submission}, courseId: @courseId, creatorType: 'User', vent: @}))
      @sliderRecalculate()

    showGroupViews: () ->
      @creatorType = 'Group'
      groupProjectsCollection = CollectionProxy(@collections.project)
      groupProjectsCollection.where((model) -> model.get('type') == 'GroupProject' || model.get('type') == 'OpenProject')

      @creators.show(new CourseMapCreators({collection: @collections.group, courseId: @courseId, vent: @, creatorType: 'Group'}))
      @projects.show(new CourseMapProjects({collection: groupProjectsCollection, courseId: @courseId, vent: @}))
      @matrix.show(new CourseMapMatrix({collection: @collections.group, collections: {project: groupProjectsCollection, submission: @collections.submission}, courseId: @courseId, creatorType: 'Group', vent: @}))
      @sliderRecalculate()

    setActive: (models) ->
      @collections.user.setActive(if models.user? then models.user.id else null)
      @collections.group.setActive(if models.group? then models.group.id else null)
      @collections.project.setActive(if models.project? then models.project.id else null)

    onShowGroups: () ->
      @showGroupViews()
      @ui.groupsInput.prop('checked', true)
      @ui.usersInput.prop('checked', false)
      Vocat.router.navigate("courses/#{@courseId}/groups/evaluations")

    onShowUsers: () ->
      @showUserViews()
      @ui.groupsInput.prop('checked', false)
      @ui.usersInput.prop('checked', true)
      Vocat.router.navigate("courses/#{@courseId}/users/evaluations")

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
      Vocat.router.navigate("courses/#{@courseId}/users/evaluations/creator/#{args.user.id}")
      view = new CourseMapDetailCreator({
        collection: @collections.submission,
        projects: @collections.project,
        courseId: @courseId,
        vent: @,
        model: args.user
      })

    onOpenDetailGroup: (args) ->
      @showGroupViews()
      @setActive({group: args.group})
      Vocat.router.navigate("courses/#{@courseId}/groups/evaluations/creator/#{args.group.id}")
      view = new CourseMapDetailCreator({collection: @collections.submission, creatorType: 'Group', courseId: @courseId, vent: @, model: args.group})

    onOpenDetailProjectUsers: (args) ->
      @showUserViews()
      @setActive({project: args.project})
      Vocat.router.navigate("courses/#{@courseId}/users/evaluations/project/#{args.project.id}")
      view = new CourseMapDetailProject({collections: {creators: @collections.user,submissions: @collections.submission}, courseId: @courseId, vent: @, model: args.project})

    onOpenDetailProjectGroups: (args) ->
      @showGroupViews()
      @setActive({project: args.project})
      Vocat.router.navigate("courses/#{@courseId}/groups/evaluations/project/#{args.project.id}")
      view = new CourseMapDetailProject({collections: {creators: @collections.group, submissions: @collections.submission}, courseId: @courseId, vent: @, model: args.project})

    onOpenDetailCreatorProject: (args) ->
      if args.creator.creatorType == 'User'
        @showUserViews()
        @setActive({project: args.project, user: args.creator})
        Vocat.router.navigate("courses/#{@courseId}/users/evaluations/creator/#{args.creator.id}/project/#{args.project.id}")
      else if args.creator.creatorType == 'Group'
        @showGroupViews()
        @setActive({project: args.project, group: args.creator})
        Vocat.router.navigate("courses/#{@courseId}/groups/evaluations/creator/#{args.creator.id}/project/#{args.project.id}")
      submission = @collections.submission.findWhere({creator_id: args.creator.id, project_id: args.project.id, creator_type: args.creator.creatorType})
      view = new CourseMapDetailCreatorProject({
        collections: { submission: @collections.submission },
        courseId: @courseId,
        vent: @,
        creator: args.creator,
        project: args.project
        model: submission
      })

    onColActive: (args) ->
      # For now, do nothing.

    onColInactive: (args) ->
      # For now, do nothing.

