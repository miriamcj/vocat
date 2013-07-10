define ['marionette', 'controllers/submission_controller'], (Marionette, SubmissionController) ->

  class SubmissionRouter extends Marionette.AppRouter

    controller: new SubmissionController

    appRoutes : {
      'courses/:course/view/creator/:creator/project/:project': 'creatorProjectDetail'
      'pages/help_dev': 'helpDev' # TODO: Delete this route and the corresponding controller method when it is no longer needed.
    }
