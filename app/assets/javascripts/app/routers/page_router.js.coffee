define ['marionette', 'controllers/page_controller'], (Marionette, PageController) ->

  class PageRouter extends Marionette.AppRouter

    controller: new PageController

    appRoutes : {
      'pages/help_dev': 'help'
    }
