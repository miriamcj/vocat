define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/annotator/annotator_input')
  AnnotationModel = require('models/annotation')
  ModalConfirmView = require('views/modal/modal_confirm')

  class AnnotatorInputView extends Marionette.LayoutView

    template: template

    ui:
      annotationInput: '[data-behavior="annotation-input"]'
      annotationCreateButton: '[data-behavior="annotation-create"]'
      annotationUpdateButton: '[data-behavior="annotation-update"]'
      annotationEditCancelButton: '[data-behavior="annotation-edit-cancel"]'
      annotationDeleteButton: '[data-behavior="annotation-delete"]'

    triggers: {
      'click @ui.annotationCreateButton': 'saveAnnotation'
      'click @ui.annotationUpdateButton': 'saveAnnotation'
      'click @ui.annotationEditCancelButton': 'cancelEdit'
    }

    events:
      'keypress [data-behavior="annotation-input"]': 'onUserTyping'

    onUserTyping: () ->
      @vent.trigger('request:pause', {})

    onSaveAnnotation: () ->
      @listenToOnce(@vent, 'announce:status', (response) =>
        seconds_timecode = response.playedSeconds;
        @model.save({
          body: @ui.annotationInput.val()
          published: true
          seconds_timecode: seconds_timecode
        }, {
          success: (annotation) => @handleAnnotationSaveSuccess(annotation)
          error: (annotation) => @handleAnnotationSaveError(annotation, xhr)
        })
      )
      @vent.trigger('request:status', {})

    onCancelEdit: () ->
      @vent.trigger('request:unlock', @)
      @vent.trigger('annotator:refresh')

    handleAnnotationSaveSuccess: (annotation) ->
      @collection.add(annotation, {merge: true})
      @vent.trigger('request:unlock', @)
      @vent.trigger('request:resume', {})
      @vent.trigger('request:status', {})
      @vent.trigger('annotator:refresh')

    handleLockAttempted: () ->
      Vocat.vent.trigger('error:add', {level: 'info', clear: true, msg: 'Playback is locked because you are currently editing an annotation. To unlock playback, press the cancel button.'})

    handleAnnotationSaveError: (annotation, xhr) ->
      Vocat.vent.trigger('error:add', {level: 'error', msg: xhr.responseJSON.errors})

    setupListeners: () ->
      @listenTo(@, 'lock:attempted', @handleLockAttempted, @)

    initialize: (options) ->
      @vent = options.vent
      @asset = options.asset
      @collection = @asset.annotations()
      @setupListeners()

    isDirty: () ->
      @ui.annotationInput.val().length > 0

    onShow: () ->
      # If we're showing an annotation that is not new, then we're editing and we want to jump to the correct point in the
      # video.
      if !@model.isNew()
        @vent.trigger('request:pause', {})
        @vent.trigger('request:time:update', {seconds: @model.get('seconds_timecode')})
        @vent.trigger('request:lock', {view: @, seconds: @model.get('seconds_timecode')})
