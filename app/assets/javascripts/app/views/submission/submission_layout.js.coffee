define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/submission_layout')
  AnnotationCollection = require('collections/annotation_collection')
  EvaluationCollection = require('collections/evaluation_collection')
  PlayerView = require('views/submission/player/player_layout')
  AnnotationsView = require('views/submission/annotations')
  AnnotatorView = require('views/submission/annotator')
  EvaluationView = require('views/submission/evaluation')
  MyEvaluationView = require('views/submission/my_evaluation')
  DiscussionView = require('views/submission/discussion')
  FlashMessagesView = require('views/flash/flash_messages')
  RubricFieldPlacard = require('views/help/rubric_field_placard')
  GlossaryTogglePlacard = require('views/help/glossary_toggle_placard')
  RubricModel = require('models/rubric')
  ProjectDetailView = require('views/project/project_detail')


  class SubmissionLayout extends Marionette.Layout

    template: template
    children: {}
    rubricPlacardsVisible: false

    triggers: {
      'mouseenter [data-trigger-glossary-toggle]': 'hover:glossary:show'
      'mouseleave [data-trigger-glossary-toggle]': 'hover:glossary:hide'
      'click [data-trigger-glossary-toggle]': 'null'
      'click [data-trigger-project-details]': 'open:project:modal'
    }

    ui: {
      glossaryToggle: '[data-trigger-glossary-toggle]'
    }

    regions: {
      flash: '[data-region="flash"]'
      instructorEvaluations: '[data-region="instructor-evaluations"]'
      peerEvaluations: '[data-region="peer-evaluations"]'
      myEvaluations: '[data-region="my-evaluations"]'
      discussion: '[data-region="discussion"]'
      upload: '[data-region="upload"]'
      annotator: '[data-region="annotator"]'
      annotations: '[data-region="annotations"]'
      player: '[data-region="player"]'
    }

    onOpenProjectModal: () ->
      console.log @project,'p'
      Vocat.vent.trigger('modal:open', new ProjectDetailView({model: @project, vent: @vent}))

    onHoverGlossaryShow: () ->
      Vocat.vent.trigger('help:show',{
        on: @ui.glossaryToggle
        orientation: 'sse'
        key: 'glossary:toggle'
        data: {}
      })

    onHoverGlossaryHide: () ->
      Vocat.vent.trigger('help:hide',{key: 'glossary:toggle'})

    onPlayerStop: () ->
      # do something

    onChangeVideoAttachmentId: (data) ->
      if @submission.get('video_attachment_id')
        @children.annotator = new AnnotatorView({model: @submission, collection: @collections.annotation, vent: @})
        @annotator.show(@children.annotator)

    onSubmissionLoaded: () ->
      if @submission.video
        @collections.annotation.fetch({data: {video: @submission.video.id}})
      @createPlacards()
      @createEvaluationViews()
      @createAnnotationView()
      @createFlashView()
      @createPlayerView()
      @createAnnotatorView()
      @createDiscussionView()

    initialize: (options) ->
      @options = options || {}
      @collections = options.collections
      @collections.annotation = new AnnotationCollection([],{})
      @vent = if options.vent? then options.vent else Vocat.vent

      babysitter = require('backbone.babysitter');
      @placards = new babysitter

      @submission = @model
      @submission.fetch({success: () =>
        @triggerMethod('submission:loaded')
      })
      @courseId = Marionette.getOption(@, 'courseId')
      @project = Marionette.getOption(@, 'project')
      @creator = Marionette.getOption(@, 'creator')

    onEvaluationCreated: () ->
      @ui.glossaryToggle.show()

    onClose: () ->
      @placards.call('remove')

    createPlacards: () ->
      if @project
        rubric = new RubricModel(@project.get('rubric'))
        rubric.get('fields').each (field) =>
          @placards.add(new RubricFieldPlacard({orientation: 'nnw', rubric: rubric, fieldId: field.id, key: "rubric:field:#{field.id}"}))
        @placards.add(new GlossaryTogglePlacard({orientation: 'nne', key: 'glossary:toggle', rubric: @project.get('rubric')}))
        @placards.call('render')

    createEvaluationViews: () ->
      evaluations = new EvaluationCollection(@submission.get('evaluations'), {courseId: @courseId})

      # If there are no evaluations, hide the glossary button
      if evaluations.length == 0 then @ui.glossaryToggle.hide()

      myEvaluationModels = evaluations.where({current_user_is_owner: true})
      myEvaluations = new EvaluationCollection(myEvaluationModels, {courseId: @courseId})
      evaluations.remove(myEvaluationModels)

      instructorEvaluationModels = evaluations.where({evaluator_role: 'Instructor'})
      instructorEvaluations = new EvaluationCollection(instructorEvaluationModels, {courseId: @courseId})
      evaluations.remove(instructorEvaluationModels)
      if @submission.get('current_user_can_evaluate') == true
        @myEvaluations.show new MyEvaluationView({collection: myEvaluations, model: @submission, project: @project, vent: @, courseId: @courseId})

      if @submission.get('current_user_is_owner') || @submission.get('current_user_is_instructor')
        # It's useful for students to see that something hasn't been scored; less useful for instructors in this context.
        unless @submission.get('current_user_is_instructor') && instructorEvaluations.length == 0
          @instructorEvaluations.show new EvaluationView({collection: instructorEvaluations, label: 'Instructor', model: @submission, project: @project, vent: @, courseId: @courseId})
        if @submission.get('course_allows_peer_review')
          @peerEvaluations.show new EvaluationView({collection: evaluations, label: 'Peer', model: @submission, project: @project, vent: @, courseId: @courseId})

    createAnnotationView: () ->
      # Create the annotations view
      if @submission.get('current_user_can_annotate')
        if @submission.attachment? then attachmentId = @submission.attachment.id else attachmentId = null
        @annotations.show new AnnotationsView({model: @submission, attachmentId: attachmentId, collection: @collections.annotation, vent: @})
      else
        $(@player.el).addClass('attachment--left-wide')

    createFlashView: () ->
      # Create the flash messages view
      @flash.show new FlashMessagesView({vent: @, clearOnAdd: true})

    createDiscussionView: () ->
      @discussion.show new DiscussionView({vent: @, submission: @submission})

    createPlayerView: () ->
      @player.show new PlayerView({vent: @, model: @submission})

    createAnnotatorView: () ->
      if @submission.get('current_user_can_annotate') && @submission.get('has_video')
        @annotator.show new AnnotatorView({model: @submission, collection: @collections.annotation, vent: @})
      else
        @annotator.close()

      @listenTo(@submission,'change:has_video', () =>
        @createAnnotatorView()
      )

    onVideoDestroyed: () ->
      @collections.annotation.videoId = null
      @collections.annotation.reset()



