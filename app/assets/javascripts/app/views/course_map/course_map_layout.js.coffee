define (require) ->

  template = require('hbs!templates/course_map/course_map_layout')
  CollectionProxy = require('collections/collection_proxy')
  CourseMapProjects = require('views/course_map/projects')
  CourseMapCreators = require('views/course_map/creators')
  CourseMapMatrix = require('views/course_map/matrix')
  CourseMapDetailCreator = require('views/course_map/detail_creator')
  CourseMapDetailProject = require('views/project/detail')
  CourseMapDetailCreatorProject = require('views/submission/submission_layout')
  AbstractMatrix = require('views/abstract/abstract_matrix')

  class CourseMapLayout extends AbstractMatrix

      children: {}
      minWidth: 170

      template: template

      ui: {
        detail: '[data-region="detail"]'
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
        detail: '[data-region="detail"]'
        creators: '[data-region="creators"]'
        projects: '[data-region="projects"]'
        matrix: '[data-region="matrix"]'
        globalFlash: '[data-region="flash"]'
      }

      onRender: () ->
        @sliderPosition = 0
        @bindUIElements()

      onShow: () ->
        @parentOnShow()

      initialize: (options) ->
        @collections = options.collections
        @courseId = options.courseId
        Vocat.vent.trigger('error:add', {level: 'notice', lifetime: '5000',  msg: 'This is a test global error message.'})

      showUserViews: () ->
        @creatorType = 'User'
        userProjectsCollection = CollectionProxy(@collections.project)
        userProjectsCollection.where((model) -> model.get('type') == 'UserProject' || model.get('type') == 'OpenProject')
        @creators.show(new CourseMapCreators({collection: @collections.user, courseId: @courseId, vent: @, creatorType: 'User'}))
        @projects.show(new CourseMapProjects({collection: userProjectsCollection, courseId: @courseId, vent: @}))
        @matrix.show(new CourseMapMatrix({collection: @collections.user, collections: {project: userProjectsCollection, submission: @collections.submission}, courseId: @courseId, creatorType: 'User', vent: @}))
        @recalculateMatrix()

      showGroupViews: () ->
        @creatorType = 'Group'
        groupProjectsCollection = CollectionProxy(@collections.project)
        groupProjectsCollection.where((model) -> model.get('type') == 'GroupProject' || model.get('type') == 'OpenProject')

        @creators.show(new CourseMapCreators({collection: @collections.group, courseId: @courseId, vent: @, creatorType: 'Group'}))
        @projects.show(new CourseMapProjects({collection: groupProjectsCollection, courseId: @courseId, vent: @}))
        @matrix.show(new CourseMapMatrix({collection: @collections.group, collections: {project: groupProjectsCollection, submission: @collections.submission}, courseId: @courseId, creatorType: 'Group', vent: @}))
        @recalculateMatrix()

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
        @openDetail(view)

      openDetail: (view) ->
        @ui.detail.show()
        @detail.show(view)

      onCloseDetail: (args) ->
        @ui.detail.hide()
        @detail.empty()

        if @creatorType == 'Group'
          Vocat.router.navigate("courses/#{@courseId}/groups/evaluations")
        else if @creatorType == 'User'
          Vocat.router.navigate("courses/#{@courseId}/users/evaluations")

        @recalculateMatrix()

      onEvaluationsPublish: (project) ->
        endpoint = "#{project.url()}/publish_evaluations"
        $.ajax(endpoint, {
          type: 'put'
          dataType: 'json'
          data: {}
          success: (data, textStatus, jqXHR) =>
            Vocat.vent.trigger('error:add', {level: 'notice', lifetime: 2000, msg: "Your evaluations for #{project.get('name')} submissions have been published"})
            @collections.submission.fetch({data: {course: @courseId}})
          error: (jqXHR, textStatus, error) =>
            # TODO: Handle error
        })

      onEvaluationsUnpublish: (project) ->
        endpoint = "#{project.url()}/unpublish_evaluations"
        $.ajax(endpoint, {
          type: 'put'
          dataType: 'json'
          data: {}
          success: (data, textStatus, jqXHR) =>
            Vocat.vent.trigger('error:add', {level: 'notice', lifetime: 2000, msg: "Your evaluations for #{project.get('name')} submissions have been unpublished"})
            @collections.submission.fetch({data: {course: @courseId}})
          error: (jqXHR, textStatus, error) =>
            # TODO: Handle error
        })

      onColActive: (args) ->
        # For now, do nothing.

      onColInactive: (args) ->
        # For now, do nothing.

