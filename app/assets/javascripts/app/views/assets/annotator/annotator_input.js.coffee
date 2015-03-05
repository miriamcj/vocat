define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/annotator/annotator_input')
  AnnotationModel = require('models/annotation')

  class AnnotatorInputView extends Marionette.ItemView

    template: template
    canvasIsDirty: false
    inputPointer: null

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
      'click @ui.canvasEraseButton': 'setCanvasModeErase'
      'click @ui.canvasOvalButton': 'setCanvasModeOval'
    }

    events:
      'keypress [data-behavior="annotation-input"]': 'onUserTyping'
      'focus [data-behavior="annotation-input"]': 'onUserFocus'

    setupListeners: () ->
      @listenTo(@, 'lock:attempted', @handleLockAttempted, @)
      @listenTo(@vent, 'announce:time:update', @handleTimeUpdate, @)
      @listenTo(@vent, 'announce:canvas:tool', @updateToolStates, @)
      @listenTo(@vent, 'announce:canvas:dirty', @handleCanvasDirty, @)
      @listenTo(@vent, 'announce:canvas:clean', @handleCanvasClean, @)
      @listenTo(@vent, 'request:annotator:input:edit', @startAnnotationEdit, @)
      @listenTo(@vent, 'request:annotator:input:reset', @stopAnnotationInput, @)

    initialize: (options) ->
      @vent = options.vent
      @asset = options.asset
      @collection = @asset.annotations()
      @setupListeners()

    startAnnotationInput: () ->
      if @inputPointer == null
        @listenToOnce(@vent, 'announce:status', (response) =>
          @inputPointer = response.playedSeconds;
          @updateCancelButtonVisibility()
          @vent.trigger('request:message:show', {msg: 'Press post to save your annotation.'}) if @model.isNew()
          @vent.trigger('request:message:show', {msg: "Enter your edits and press update to save."}) if !@model.isNew()
          @vent.trigger('announce:annotator:input:start', {})
          @vent.trigger('annotation:canvas:load', @model)
        )
        @vent.trigger('request:status', {})

    startAnnotationEdit: (annotation) ->
      @vent.trigger('request:time:update', {seconds: annotation.get('seconds_timecode'), callback: () =>
        @model = annotation
        @render()
        @startAnnotationInput()
      , callbackScope: @})

    stopAnnotationInput: (forceModelReset = false) ->
      if @inputPointer != null
        @inputPointer = null
        @vent.trigger('announce:annotator:input:stop', {})
        @vent.trigger('annotation:canvas:disable')
        @vent.trigger('request:resume', {})
        @vent.trigger('request:message:hide')
        if !@model.isNew() || forceModelReset
          @model = new AnnotationModel({asset_id: @asset.id})
          @render()

    handleTimeUpdate: (data) ->
      if @inputPointer && data.playedSeconds != @inputPointer
        @stopAnnotationInput()

    updateCancelButtonVisibility: () ->
      if @inputPointer != null
        @ui.annotationCreateCancelButton.show()
      else
        @ui.annotationCreateCancelButton.hide()

    onUserFocus: (event) ->
      @startAnnotationInput()

    onUserTyping: () ->
      @startAnnotationInput()

    onSetCanvasModeDraw: () ->
      @startAnnotationInput()
      @vent.trigger('annotation:canvas:setmode', 'draw')

    onSetCanvasModeErase: () ->
      @startAnnotationInput()
      @vent.trigger('annotation:canvas:setmode', 'erase')

    onSetCanvasModeOval: () ->
      @startAnnotationInput()
      @vent.trigger('annotation:canvas:setmode', 'oval')

    onSaveAnnotation: () ->
      body = @ui.annotationInput.val()
      @vent.trigger('request:annotator:save', @model, {body: body})
      forceModelReset = true
      @stopAnnotationInput(forceModelReset)

    onCancelEdit: () ->
      forceModelReset = true
      @stopAnnotationInput(forceModelReset)

    handleLockAttempted: () ->
      Vocat.vent.trigger('error:add', {level: 'info', clear: true, msg: 'Playback is locked because you are currently editing an annotation. To unlock playback, press the cancel button.'})

    takeFocus: () ->
      @ui.annotationInput.focus()

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

    isDirty: () ->
      @ui.annotationInput.val().length > 0 or @canvasIsDirty == true

    onRender: () ->
      @updateCancelButtonVisibility()

    onShow: () ->
      @updateCancelButtonVisibility()
      if !@asset.allowsVisibleAnnotation()
        @hideVisualAnnotationUi()
