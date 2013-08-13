define ['marionette', 'controllers/rubric_controller'], (Marionette, RubricController) ->

  class RubricRouter extends Marionette.AppRouter

    controller: new RubricController

    appRoutes : {
      'courses/:course/manage/rubrics/new': 'new'
      'rubrics/new': 'new'
      'courses/:course/manage/rubrics/:rubric/edit': 'edit'
      'rubrics/:rubric/edit': 'editWithoutCourse'
    }

