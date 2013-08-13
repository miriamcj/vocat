define [
  'marionette',
  'hbs!templates/submission/submission_layout',
  'collections/submission_collection',
  'collections/annotation_collection',
  'collections/evaluation_collection',
  'views/submission/player',
  'views/submission/annotations',
  'views/submission/annotator',
  'views/submission/evaluation',
  'views/submission/my_evaluation',
  'views/submission/upload',
  'views/submission/upload/failed',
  'views/submission/upload/started',
  'views/submission/upload/transcoding',
  'views/submission/upload/start',
  'views/submission/discussion',
  'views/flash/flash_messages',
  'views/help/rubric_field_placard',
  'views/help/glossary_toggle_placard',
  'models/attachment',
  'models/rubric',
  'app/plugins/backbone_poller'
], (
  Marionette, template, SubmissionCollection, AnnotationCollection, EvaluationCollection, PlayerView, AnnotationsView, AnnotatorView, EvaluationView, MyEvaluationView, UploadView, UploadFailedView, UploadStartedView, UploadTranscodingView, UploadStartView, DiscussionView, FlashMessagesView, RubricFieldPlacard, GlossaryTogglePlacard, Attachment, RubricModel, Poller
) ->

  class SubmissionLayout extends Marionette.Layout

    template: template
    children: {}
    rubricPlacardsVisible: false

    triggers: {
      'mouseenter [data-trigger-glossary-toggle]': 'hover:glossary:show'
      'mouseleave [data-trigger-glossary-toggle]': 'hover:glossary:hide'
      'click [data-trigger-glossary-toggle]': 'null'
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

    onSubmissionFound: () ->
      @submission.fetch({
        success: () =>
          @triggerMethod('submission:loaded')
      })

    onSubmissionLoaded: () ->
      @createPlacards()
      @createEvaluationViews()
      @createAnnotationView()
      @createUploadView()
      @createFlashView()
      @createPlayerView()
      @createDiscussionView()

    initialize: (options) ->
      @options = options || {}
      @collections = options.collections
      @collections.annotation = new AnnotationCollection([],{})

      babysitter = require('backbone.babysitter');
      @placards = new babysitter

      @courseId = Marionette.getOption(@, 'courseId')
      @project = Marionette.getOption(@, 'project')
      @creator = Marionette.getOption(@, 'creator')

      # Load the submission for this view and then instantiate all child views
      @submission = @collections.submission.findWhere({project_id: @project.id, creator_id: @creator.id})
      if !@submission
        temporaryCollection = new SubmissionCollection([], {courseId: @courseId})
        temporaryCollection.fetch({data: {project: @project.id, creator: @creator.id}, success: () =>
          @submission = temporaryCollection.pop()
          @collections.submission.add(@submission)
          @triggerMethod('submission:found')
        })
      else
        @triggerMethod('submission:found')

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

    createUploadView: () ->
      # Create the upload view
      if @submission.get('current_user_can_attach')
        @upload.show new UploadView({model: @submission, collection: @collections.submission, vent: @})

    createFlashView: () ->
      # Create the flash messages view
      @flash.show new FlashMessagesView({vent: @, clearOnAdd: true})

    createDiscussionView: () ->
      @discussion.show new DiscussionView({vent: @, submission: @submission})

    createPlayerView: () ->
      # Create the player view
      @getPlayerView()

    startPolling: () ->
      options = {
        delay: 1000
        delayed: true
        condition: (attachment) =>
          results = attachment.get('transcoding_success') == true
          if results
            @triggerMethod('attachment:transcoding:completed', {attachment: attachment})
            out = false
          else
            out = true
          out
      }
      poller = Poller.get(@submission.attachment, options);
      poller.start()

    getPlayerView: () ->
      if !@submission.attachment?
        @triggerMethod('attachment:destroyed')
      else
        attachment = @submission.attachment
        if attachment
          if attachment.get('transcoding_busy') then @triggerMethod('attachment:upload:done')
          if attachment.get('transcoding_error') then @triggerMethod('attachment:transcoding:failed')
          if attachment.get('transcoding_success') then @triggerMethod('attachment:transcoding:completed')

    onAttachmentTranscodingCompleted: (data) ->
      if data? && data.attachment?
        @collections.annotation.fetch({data: {attachment: data.attachment.id}})
      @player.show(new PlayerView({model: @submission.attachment, submission: @submission, vent: @}))
      if @submission.get('current_user_can_annotate')
        @annotator.show new AnnotatorView({model: @submission, collection: @collections.annotation, vent: @})

    onAttachmentUploadDone: () ->
      @player.show(new UploadTranscodingView({}))
      @trigger('upload:close')
      @startPolling()

    onAttachmentDestroyed: () ->
      @collections.annotation.attachmentId = null
      @collections.annotation.reset()
      @player.show(new UploadStartView({vent: @}))
      @annotator.close()

    onAttachmentUploadFailed: () ->
      @player.show(new UploadFailedView({}))

    onAttachmentUploadStarted: () ->
      @player.show(new UploadStartedView({}))



