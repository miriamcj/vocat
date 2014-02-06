define (require) ->

  VocatController = require('controllers/vocat_controller')
  UserCollection = require('collections/user_collection')
  ProjectCollection = require('collections/project_collection')
  SubmissionForCourseCollection = require('collections/submission_for_course_collection')
  GroupCollection = require('collections/group_collection')
  CourseMap = require('views/course_map/course_map_layout')
  ProjectDetail = require('views/course_map/detail_project')

  class CourseMapController extends VocatController

    collections: {
      user: new UserCollection([], {})
      group: new GroupCollection([], {})
      project: new ProjectCollection([], {})
      submission: new SubmissionForCourseCollection([], {})
    }

    layoutInitialized: false

    initialize: () ->
      @bootstrapCollections()

    setupCoursemap: (courseId) ->

      # If we already have @courseMap, then the data has already been fetched.
      if @courseMap
        deferred = $.Deferred()
        deferred.resolve()
        deferred
      # Otherwise, setup @courseMap and load the data. Routes won't execute until
      # the loading is complete.
      else
        @collections.submission = new SubmissionForCourseCollection
        deferred = @deferredCollectionFetching(@collections.submission, {course: courseId}, 'Loading course submissions...')
        $.when(deferred).then(() =>
          @courseMap = new CourseMap({courseId: courseId, collections: @collections})
          window.Vocat.main.show(@courseMap)
        )
        deferred

    userGrid: (courseId) ->
      deferred = @setupCoursemap(courseId)
      $.when(deferred).then(() =>
        @courseMap.triggerMethod('show:users', {})
      )

    userCreatorDetail: (courseId, userId) ->
      deferred = @setupCoursemap(courseId)
      $.when(deferred).then(() =>
        @courseMap.triggerMethod('open:detail:user', {user: @collections.user.get(userId)})
      )

    userProjectDetail: (courseId, projectId) ->
      deferred = @setupCoursemap(courseId)
      $.when(deferred).then(() =>
        @courseMap.triggerMethod('open:detail:project:users', {project: @collections.project.get(projectId)})
      )

    userCreatorProjectDetail: (courseId, creatorId, projectId) ->
      deferred = @setupCoursemap(courseId)
      $.when(deferred).then(() =>
        @courseMap.triggerMethod('open:detail:creator:project', {
          creator: @collections.user.get(creatorId),
          project: @collections.project.get(projectId)
        })
      )

    standaloneUserProjectDetail: (courseId, projectId) ->
      projectDetail = new ProjectDetail({courseId: courseId, collections: @collections, vent: Vocat.vent, projectId: projectId})
      window.Vocat.main.show(projectDetail)

    groupGrid: (courseId) ->
      deferred = @setupCoursemap(courseId)
      $.when(deferred).then(() =>
        @courseMap.triggerMethod('show:groups', {})
      )

    groupCreatorDetail: (courseId, groupId) ->
      deferred = @setupCoursemap(courseId)
      $.when(deferred).then(() =>
        @courseMap.triggerMethod('open:detail:group', {group: @collections.group.get(groupId)})
      )

    groupProjectDetail: (courseId, projectId) ->
      deferred = @setupCoursemap(courseId)
      $.when(deferred).then(() =>
        @courseMap.triggerMethod('open:detail:project:groups', {project: @collections.project.get(projectId)})
      )

    groupCreatorProjectDetail: (courseId, creatorId, projectId) ->
      deferred = @setupCoursemap(courseId)
      $.when(deferred).then(() =>
        @courseMap.triggerMethod('open:detail:creator:project', {
          creator: @collections.group.get(creatorId),
          project: @collections.project.get(projectId)
        })
      )
