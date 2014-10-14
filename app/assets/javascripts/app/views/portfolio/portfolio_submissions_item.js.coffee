define ['marionette', 'hbs!templates/portfolio/portfolio_item_submission'], (Marionette, SubmissionTemplate) ->
  class PortfolioItemSubmission extends Marionette.ItemView

    template: SubmissionTemplate
    className: 'portfolio-frame'

    defaults: {
      showCourse: true
      showCreator: true
    }

    initialize: (options) ->
      options = _.extend(@defaults, options);
      @showCourse = options.showCourse
      @showCreator = options.showCreator
      @listenTo(@model, 'change', () =>
        @render()
      )


    serializeData: () ->
      data = super()
      out = {
        submission: data
        showCourse: @showCourse
        showCreator: @showCreator
      }
      out

