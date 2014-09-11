define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/submission_layout')
  DiscussionView = require('views/discussion/discussion')
  EvaluationsView = require('views/submission/evaluations/evaluations_layout')

#  AnnotationCollection = require('collections/annotation_collection')
#  EvaluationCollection = require('collections/evaluation_collection')
#  PlayerView = require('views/submission/player/player_layout')
#  AnnotationsView = require('views/submission/annotations')
#  AnnotatorView = require('views/submission/annotator')
#  EvaluationView = require('views/submission/evaluation')
#  MyEvaluationView = require('views/submission/my_evaluation')
#  DiscussionView = require('views/submission/discussion')
#  FlashMessagesView = require('views/flash/flash_messages')
#  RubricFieldPlacard = require('views/help/rubric_field_placard')
#  GlossaryTogglePlacard = require('views/help/glossary_toggle_placard')
#  RubricModel = require('models/rubric')
#  ProjectDialogView = require('views/project/dialog')
#  RubricDetailView = require('views/rubric/rubric_detail')


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

