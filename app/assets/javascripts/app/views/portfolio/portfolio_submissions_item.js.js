define (require) ->
  Marionette = require('marionette')
  SubmissionTemplate = require('hbs!templates/portfolio/portfolio_item_submission')

  class PortfolioItemSubmission extends Marionette.ItemView

    template: SubmissionTemplate
    className: 'page-section portfolio-item portfolio-course-submissions'
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
      typeSegment = "#{@model.get('creator_type').toLowerCase()}s"
      url = "courses/#{@courseId}/#{typeSegment}/evaluations/creator/#{@model.get('creator_id')}/project/#{@model.get('project_id')}"
      Vocat.router.navigate(url, true)

    setupListeners: () ->
      @listenTo(@model, 'change', () =>
        @render()
      )


    initialize: (options) ->
      @courseId = Marionette.getOption(@, 'courseId')
      @standalone = Marionette.getOption(@, 'standalone')
      @vent = Marionette.getOption(@, 'vent')
      @creator = Marionette.getOption(@, 'creator')
      @setupListeners()

    serializeData: () ->
      data = super()
      out = {
        submission: data
        isGroupProject: @model.get('creator_type') == 'Group'
      }
      out

