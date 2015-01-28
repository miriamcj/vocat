define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/annotator/annotator_input')
  AnnotationModel = require('models/annotation')

  class AnnotatorInputView extends Marionette.ItemView

    template: template
    canvasIsDirty: false

    ui:
      annotationInput: '[data-behavior="annotation-input"]'
      canvasDrawButton: '[data-behavior="annotation-canvas-draw"]'
      canvasEraseButton: '[data-behavior="annotation-canvas-erase"]'
      canvasOvalButton: '[data-behavior="annotation-canvas-oval"]'
      annotationCreateButton: '[data-behavior="annotation-create"]'
      annotationCreateCancelButton: '[data-behavior="annotation-create-cancel"]'
      annotationUpdateButton: '[data-behavior="annotation-update"]'
      annotationEditCancelButton: '[data-behavior="annotation-edit-cancel"]'
      annotationDeleteButton: '[data-behavior="annotation-delete"]'

    triggers: {
      'click @ui.annotationCreateButton': 'saveAnnotation'
      'click @ui.annotationCreateCancelButton': 'cancelEdit'
      'click @ui.annotationUpdateButton': 'saveAnnotation'
      'click @ui.annotationEditCancelButton': 'cancelEdit'
      'click @ui.canvasDrawButton': 'setCanvasModeDraw'
      'click @ui.canvasEraseButton': 'canvasErase'
      'click @ui.canvasOvalButton': 'setCanvasModeOval'
    }

    events:
      'keypress [data-behavior="annotation-input"]': 'onUserTyping'
      'keyup [data-behavior="annotation-input"]': 'onUserKeyup'

    onUserKeyup: () ->
      @updateCancelButtonVisibility()

    updateCancelButtonVisibility: () ->
      if @ui.annotationInput.val().length > 0
        @ui.annotationCreateCancelButton.show()
      else
        @ui.annotationCreateCancelButton.hide()

    onUserTyping: () ->
      @vent.trigger('request:pause', {})

    onSetCanvasModeDraw: () ->
      @vent.trigger('annotation:canvas:enable')
      @vent.trigger('annotation:canvas:setmode', 'draw')

    onCanvasErase: () ->
      @vent.trigger('annotation:canvas:enable')
      @vent.trigger('annotation:canvas:setmode', 'erase')

    onSetCanvasModeOval: () ->
      @vent.trigger('annotation:canvas:enable')
      @vent.trigger('annotation:canvas:setmode', 'oval')

    onSaveAnnotation: () ->
      @listenToOnce(@vent, 'announce:status', (response) =>
        @listenToOnce(@vent, 'announce:canvas', (canvas) =>
          seconds_timecode = response.playedSeconds;
          @model.save({
            canvas: canvas
            body: @ui.annotationInput.val()
            published: true
            seconds_timecode: seconds_timecode
          }, {
            success: (annotation) => @handleAnnotationSaveSuccess(annotation)
            error: (annotation, xhr) => @handleAnnotationSaveError(annotation, xhr)
          })
        )
        @vent.trigger('request:canvas', {})
      )
      @vent.trigger('request:status', {})

    onCancelEdit: () ->
      @vent.trigger('annotation:canvas:disable')
      @vent.trigger('request:unlock', @)
      @vent.trigger('annotator:refresh')

    handleAnnotationSaveSuccess: (annotation) ->
      @collection.add(annotation, {merge: true})
      @collection.activateModel(annotation)
      annotation.trigger('change:active')
      @vent.trigger('request:unlock', @)
      @vent.trigger('request:resume', {})
      @vent.trigger('request:status', {})
      @vent.trigger('annotation:canvas:disable')
      @vent.trigger('annotator:refresh')

    handleLockAttempted: () ->
      Vocat.vent.trigger('error:add', {level: 'info', clear: true, msg: 'Playback is locked because you are currently editing an annotation. To unlock playback, press the cancel button.'})

    handleAnnotationSaveError: (annotation, xhr) ->
      Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: xhr.responseJSON.errors})

    setupListeners: () ->
      @listenTo(@, 'lock:attempted', @handleLockAttempted, @)
      @listenTo(@vent, 'announce:canvas:tool', @updateToolStates, @)
      @listenTo(@vent, 'announce:canvas:dirty', @handleCanvasDirty, @)
      @listenTo(@vent, 'announce:canvas:clean', @handleCanvasClean, @)

    handleCanvasDirty: () ->
      @canvasIsDirty = true

    handleCanvasClean: () ->
      @canvasIsDirty = false

    updateToolStates: (activeTool) ->
      @ui.canvasDrawButton.removeClass('active')
      @ui.canvasEraseButton.removeClass('active')
      @ui.canvasOvalButton.removeClass('active')
      if activeTool == 'draw'
        @ui.canvasDrawButton.addClass('active')
      if activeTool == 'oval'
        @ui.canvasOvalButton.addClass('active')
      if activeTool == 'erase'
        @ui.canvasEraseButton.addClass('active')

    hideVisualAnnotationUi: () ->
      @ui.canvasEraseButton.hide()
      @ui.canvasDrawButton.hide()
      @ui.canvasOvalButton.hide()

    initialize: (options) ->
      @vent = options.vent
      @asset = options.asset
      @collection = @asset.annotations()
      @setupListeners()

    isDirty: () ->
      @ui.annotationInput.val().length > 0 or @canvasIsDirty == true

    onShow: () ->
      # If we're showing an annotation that is not new, then we're editing and we want to jump to the correct point in the
      # video.
      if !@model.isNew()
        @vent.trigger('request:pause', {})
        @vent.trigger('request:time:update', {seconds: @model.get('seconds_timecode')})
        @vent.trigger('request:lock', {view: @, seconds: @model.get('seconds_timecode')})
      @updateCancelButtonVisibility()
      if !@asset.allowsVisibleAnnotation()
        @hideVisualAnnotationUi()
