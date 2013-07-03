define [
  'marionette', 'controllers/vocat_controller', 'collections/creator_collection', 'collections/project_collection', 'collections/submission_collection', 'views/course_map/course_map_layout'
], (
  Marionette, VocatController, CreatorCollection, ProjectCollection, SubmissionCollection, CourseMap
) ->

  class CourseMapController extends VocatController

    collections: {
      creator: new CreatorCollection({})
      project: new ProjectCollection({})
      submission: new SubmissionCollection({})
    }

    layoutInitialized: false

    initializeLayout: (courseId) ->
      @collections.submission.courseId = courseId
      if @layoutInitialized == false
        @courseMap = new CourseMap({courseId: courseId, collections: @collections})
        window.Vocat.main.show(@courseMap)
        @layoutInitialized = true

    grid: (courseId) ->
      @initializeLayout(courseId)

    creatorDetail: (courseId, creatorId) ->
      @initializeLayout(courseId)
      @courseMap.triggerMethod('open:detail:creator', {creator: creatorId})

    projectDetail: (courseId, projectId) ->
      @initializeLayout(courseId)
      @courseMap.triggerMethod('open:detail:project', {project: projectId})

    creatorProjectDetail: (courseId, creatorId, projectId) ->
      @initializeLayout(courseId)
      @courseMap.triggerMethod('open:detail:creator:project', {creator: creatorId, project: projectId})
