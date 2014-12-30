define (require) ->
  Marionette = require('marionette')
  SubmissionTemplate = require('hbs!templates/portfolio/portfolio_item_submission')

  class PortfolioItemSubmission extends Marionette.ItemView

    template: SubmissionTemplate
    className: 'page-section--subsection page-section--subsection-ruled portfolio-item'
    standalone: false

    triggers: () ->
      t = {
      }
      if @standalone != true
        t['click @ui.submissionLink'] = 'open:submission'
      t

    ui: {
      submissionLink: '[data-behavior="open-submission-detail"]'
    }

    onOpenSubmission: () ->
      args = {
        project: @model.get('project_id')
        creator: @creator
      }
      @vent.triggerMethod('open:detail:creator:project', args)


    setupListeners: () ->
      @listenTo(@model, 'change', () =>
        @render()
      )

    initialize: (options) ->
      @standalone = Marionette.getOption(@, 'standalone')
      @vent = Marionette.getOption(@, 'vent')
      @creator = Marionette.getOption(@, 'creator')
      @setupListeners()

    serializeData: () ->
      data = super()
      out = {
        submission: data
      }
      out

