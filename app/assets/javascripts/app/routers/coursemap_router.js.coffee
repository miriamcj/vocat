define ['marionette', 'controllers/coursemap_controller'], (Marionette, CourseMapController) ->

  class CourseMapRouter extends Marionette.AppRouter

    controller: new CourseMapController

    appRoutes : {
      'courses/:course/users/evaluations': 'userGrid'
      'courses/:course/users/evaluations/creator/:creator': 'userCreatorDetail'
      'courses/:course/users/evaluations/project/:project': 'userProjectDetail'
      'courses/:course/users/evaluations/creator/:creator/project/:project': 'userCreatorProjectDetail'
      'courses/:course/groups/evaluations': 'groupGrid'
      'courses/:course/groups/evaluations/creator/:creator': 'groupCreatorDetail'
      'courses/:course/groups/evaluations/project/:project': 'groupProjectDetail'
      'courses/:course/groups/evaluations/creator/:creator/project/:project': 'groupCreatorProjectDetail'
    }
