define ['marionette', 'hbs!templates/portfolio/portfolio'], (Marionette, Template) ->

  class PortfolioView extends Marionette.LayoutView

    template: Template

    regions: {
      submissions: '[data-region="submissions"]'
      projects: '[data-region="projects"]'
    }

