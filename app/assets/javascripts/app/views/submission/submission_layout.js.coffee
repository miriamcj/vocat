define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/submission_layout')
  DiscussionView = require('views/discussion/discussion')
  EvaluationsView = require('views/submission/evaluations/evaluations_layout')
  AssetsView = require('views/submission/assets/assets_layout')

  class SubmissionLayout extends Marionette.LayoutView

    template: template
    children: {}

    triggers: () ->
      t = {
      }
      if _.isFunction(@vent.triggerMethod)
        t['click @ui.close'] = 'close'
      t


    ui: {
      close: '[data-behavior="detail-close"]'
    }

    regions: {
      flash: '[data-region="flash"]'
      evaluations: '[data-region="submission-evaluations"]'
      discussion: '[data-region="submission-discussion"]'
      assets: '[data-region="submission-assets"]'
    }

    serializeData: () ->
      sd ={
        project: @project.toJSON()
        courseId: @courseId
        creator: @creator.toJSON()
        creatorType: @submission.get('creator_type')
      }
      sd

    onShow: () ->

    onClose: () ->
      @vent.triggerMethod('close:detail') if _.isFunction(@vent.triggerMethod)

    onSubmissionLoaded: () ->
      @discussion.show(new DiscussionView({vent: @vent, submission: @submission}))
      @evaluations.show(new EvaluationsView({vent: @vent, project: @project, model: @submission, courseId: @courseId}))
      @assets.show(new AssetsView({vent: @vent, model: @submission, courseId: @courseId}))

    initialize: (options) ->
      @options = options || {}
      @vent = if options.vent? then options.vent else Vocat.vent
      @collections = {}
      @submission = @model

      @courseId = Marionette.getOption(@, 'courseId')
      @project = Marionette.getOption(@, 'project')
      @creator = Marionette.getOption(@, 'creator')

      # Load submission detail
      @submission.fetch({success: () =>
        @triggerMethod('submission:loaded')
      })

