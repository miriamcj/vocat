define [
  'marionette', 'controllers/vocat_controller', 'collections/creator_collection', 'collections/project_collection', 'views/course_map/course_map', 'views/course_map/course_map_projects', 'views/course_map/course_map_creators'
], (
  Marionette, VocatController, CreatorCollection, ProjectCollection, CourseMap, CourseMapCreators, CourseMapProjects
) ->

  class CourseMapController extends VocatController

    collections: {
      creator: new CreatorCollection({})
      project: new ProjectCollection({})
    }

    initialize: () ->
      super()

      @courseMap = new CourseMap().render()

      @creators = new CourseMapCreators({collection: @collections.creator, courseId: 12})
      @projects = new CourseMapProjects({collection: @collections.project, courseId: 12})

      @courseMap.creators.show(@creators)
      @courseMap.projects.show(@projects)


      Vocat = require(['app/vocat'], (Vocat) =>
          Vocat.main.show(@courseMap)
      )

    grid: (course) ->






    creatorDetail: (course, creator) ->
      console.log "called creatorDetail action with course #{course} and creator #{creator}"

    projectDetail: (course, project) ->
      console.log "called projectDetail action with course #{course} and project #{project}"

    creatorProjectDetail: (course, creator, project) ->
      console.log "called creatorProjectDetail action with course #{course} and creator #{creator} and project #{project}"