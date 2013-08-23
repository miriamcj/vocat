define ['marionette', 'hbs!templates/portfolio/portfolio'], (Marionette, Template) ->

  class PortfolioView extends Marionette.Layout

    template: Template

    regions: {
      submissions: '[data-region="submissions"]'
      projects: '[data-region="projects"]'
    }

