define ['marionette', 'hbs!templates/portfolio/portfolio_item_submission'], (Marionette, SubmissionTemplate) ->
  class PortfolioItemSubmission extends Marionette.ItemView

    template: SubmissionTemplate

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
        submission: data
        showCourse: @showCourse
        showCreator: @showCreator
      }
