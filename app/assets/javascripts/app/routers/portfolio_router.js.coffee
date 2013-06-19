define ['marionette', 'controllers/portfolio_controller'], (Marionette, PortfolioController) ->

  class PortfolioRouter extends Marionette.AppRouter

    controller: new PortfolioController

    appRoutes : {
#      '': 'portfolio'
      'courses/:course/portfolio': 'portfolio'
    }
