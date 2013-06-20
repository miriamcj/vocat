define [
  'marionette', 'controllers/vocat_controller', 'collections/creator_collection', 'collections/project_collection', 'views/course_map/course_map'
], (
  Marionette, VocatController, CreatorCollection, ProjectCollection, CourseMap
) ->

  class CourseMapController extends VocatController

    collections: {
      creator: new CreatorCollection({})
      project: new ProjectCollection({})
    }

    layoutInitialized: false

    initializeLayout: (courseId) ->
      if @layoutInitialized == false
        @courseMap = new CourseMap({courseId: courseId, collections: @collections})
        window.Vocat.main.show(@courseMap)
        @layoutInitialized = true

    grid: (courseId) ->
      @initializeLayout(courseId)

    creatorDetail: (courseId, creatorId) ->
      @initializeLayout(courseId)

    projectDetail: (courseId, projectId) ->
      @initializeLayout(courseId)

    creatorProjectDetail: (courseId, creatorId, projectId) ->
      console.log "called projectDetail action with course #{course} and project #{project}"
