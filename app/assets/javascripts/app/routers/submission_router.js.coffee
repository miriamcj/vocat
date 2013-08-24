define ['marionette', 'controllers/submission_controller'], (Marionette, SubmissionController) ->

  class SubmissionRouter extends Marionette.AppRouter

    controller: new SubmissionController

    appRoutes : {
      'courses/:course/view/project/:project': 'creatorProjectDetail'
    }
