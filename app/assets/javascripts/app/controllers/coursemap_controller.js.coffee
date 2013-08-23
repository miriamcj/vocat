define [
  'marionette',
  'controllers/vocat_controller',
  'collections/user_collection',
  'collections/project_collection',
  'collections/submission_collection',
  'collections/group_collection',
  'views/course_map/course_map_layout'
], (
  Marionette, VocatController, UserCollection, ProjectCollection, SubmissionCollection, GroupCollection, CourseMap
) ->

  class CourseMapController extends VocatController

    collections: {
      user: new UserCollection([], {})
      group: new GroupCollection([], {})
      project: new ProjectCollection([], {})
      submission: new SubmissionCollection([], {})
    }

    layoutInitialized: false

    initialize: () ->
      @bootstrapCollections()

    createCoursemap: () ->
      unless @courseMap instanceof CourseMap
        @courseMap = new CourseMap({courseId: @collections.project.first().get('course_id'), collections: @collections})
        window.Vocat.main.show(@courseMap)

    userGrid: (courseId) ->
      @createCoursemap()
      @courseMap.triggerMethod('show:users', {})

    userCreatorDetail: (courseId, userId) ->
      @createCoursemap()
      @courseMap.triggerMethod('open:detail:user', {user: @collections.user.get(userId)})

    userProjectDetail: (courseId, projectId) ->
      @createCoursemap()
      @courseMap.triggerMethod('open:detail:project:users', {project: @collections.project.get(projectId)})

    userCreatorProjectDetail: (courseId, creatorId, projectId) ->
      @createCoursemap()
      @courseMap.triggerMethod('open:detail:creator:project', {
        creator: @collections.user.get(creatorId),
        project: @collections.project.get(projectId)
      })

    groupGrid: (courseId) ->
      @createCoursemap()
      @courseMap.triggerMethod('show:groups', {})

    groupCreatorDetail: (courseId, groupId) ->
      @createCoursemap()
      @courseMap.triggerMethod('open:detail:group', {group: @collections.group.get(groupId)})

    groupProjectDetail: (courseId, projectId) ->
      @createCoursemap()
      @courseMap.triggerMethod('open:detail:project:groups', {project: @collections.project.get(projectId)})

    groupCreatorProjectDetail: (courseId, creatorId, projectId) ->
      @createCoursemap()
      @courseMap.triggerMethod('open:detail:creator:project', {
        creator: @collections.group.get(creatorId),
        project: @collections.project.get(projectId)
      })
