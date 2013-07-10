define ['marionette', 'hbs!templates/portfolio/portfolio_item_project'], (Marionette, ProjectTemplate) ->

  class PortfolioItemSubmission extends Marionette.ItemView

    template: ProjectTemplate

    className: 'portfolio-frame'

    defaults: {
      showCourse: true
      showCreator: true
    }

    initialize: (options) ->
      options = _.extend(@defaults, options);
      @showCourse = options.showCourse
      @showCreator = options.showCreator

    serializeData: () ->
      data = super()
      {
        project: data
        showCourse: @showCourse
        showCreator: @showCreator
      }
