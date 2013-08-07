define ['marionette', 'controllers/rubric_controller'], (Marionette, RubricController) ->

  class RubricRouter extends Marionette.AppRouter

    controller: new RubricController

    appRoutes : {
      'courses/:course/rubrics/new': 'new'
      'rubrics/:rubric/edit': 'edit'
    }
