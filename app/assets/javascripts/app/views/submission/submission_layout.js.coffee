define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/submission_layout')
  DiscussionView = require('views/discussion/discussion')

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

    triggers: {
    }

    ui: {
    }

    regions: {
      flash: '[data-region="flash"]'
      scores: '[data-region="submission-scores"]'
      discussion: '[data-region="submission-discussion"]'
      assets: '[data-region="submission-assets"]'
    }

    serializeData: () ->
      {
        project: @project.toJSON()
        creator: @creator.toJSON()
      }

    onSubmissionLoaded: () ->
      @discussion.show(new DiscussionView({vent: @vent, submission: @submission}))

    initialize: (options) ->
      @options = options || {}
      @vent = if options.vent? then options.vent else Vocat.vent

      @collections = {}
      @submission = @model

      # Load submission detail
      @submission.fetch({success: () =>
        @triggerMethod('submission:loaded')
      })

      @courseId = Marionette.getOption(@, 'courseId')
      @project = Marionette.getOption(@, 'project')
      @creator = Marionette.getOption(@, 'creator')