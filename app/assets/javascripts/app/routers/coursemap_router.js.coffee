define ['marionette', 'controllers/coursemap_controller'], (Marionette, CourseMapController) ->

  class CourseMapRouter extends Marionette.AppRouter

    controller: new CourseMapController

    appRoutes : {
      'courses/:course/evaluations': 'grid'
      'courses/:course/evaluations/creator/:creator': 'creatorDetail'
      'courses/:course/evaluations/project/:project': 'projectDetail'
      'courses/:course/evaluations/creator/:creator/project/:project': 'creatorProjectDetail'
    }
