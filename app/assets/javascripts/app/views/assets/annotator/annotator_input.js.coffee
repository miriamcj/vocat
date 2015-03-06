define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/annotator/annotator_input')
  AnnotationModel = require('models/annotation')

  class AnnotatorInputView extends Marionette.ItemView

    template: template
    canvasIsDirty: false
    editLock: false
    inputPointer: null
    ignoreTimeUpdates: false

    ui:
      annotationInput: '[data-behavior="annotation-input"]'
      canvasDrawButton: '[data-behavior="annotation-canvas-draw"]'
      canvasEraseButton: '[data-behavior="annotation-canvas-erase"]'
      canvasOvalButton: '[data-behavior="annotation-canvas-oval"]'
      canvasSelectButton: '[data-behavior="annotation-canvas-select"]'
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
      'click @ui.canvasSelectButton': 'setCanvasModeSelect'
    }

    events:
      'keypress [data-behavior="annotation-input"]': 'onUserTyping'
      'focus [data-behavior="annotation-input"]': 'onUserFocus'

    setupListeners: () ->
      @listenTo(@, 'lock:attempted', @handleLockAttempted, @)
      @listenTo(@vent, 'announce:canvas:tool', @updateToolStates, @)
      @listenTo(@vent, 'announce:canvas:dirty', @handleCanvasDirty, @)
      @listenTo(@vent, 'announce:canvas:clean', @handleCanvasClean, @)
      @listenTo(@vent, 'request:annotator:input:edit', @startAnnotationEdit, @)
      @listenTo(@vent, 'request:annotator:input:stop', @stopAnnotationInput, @)

    initialize: (options) ->
      @vent = options.vent
      @asset = options.asset
      @collection = @asset.annotations()
      @setupListeners()

    startAnnotationInput: () ->
      if @inputPointer == null
        @listenToOnce(@vent, 'announce:status', (response) =>
          @inputPointer = response.playedSeconds;
          @updateButtonVisibility()
          @onSetCanvasModeSelect()
          @vent.trigger('request:message:show', {msg: 'Press post to save your annotation.'}) if @model.isNew()
          @vent.trigger('request:message:show', {msg: "Enter your edits and press update to save."}) if !@model.isNew()
          @vent.trigger('request:annotation:canvas:load', @model)
          @vent.trigger('announce:annotator:input:start', {})
        )
        @vent.trigger('request:status', {})

    startAnnotationEdit: (annotation) ->
      @editLock = true
      @vent.trigger('request:time:update', {silent: true, seconds: annotation.get('seconds_timecode'), callback: () =>
        @editLock = false
        @model = annotation
        @model.activate()
        @render()
        @startAnnotationInput()
      , callbackScope: @})

    stopAnnotationInput: (forceModelReset = false) ->
      if @inputPointer != null & !@editLock
        @inputPointer = null
#        @vent.trigger('request:unlock', {view: @})
        @vent.trigger('announce:annotator:input:stop', {})
        @vent.trigger('request:annotation:canvas:disable')
        @vent.trigger('request:resume')
        @vent.trigger('request:message:hide')
        @updateButtonVisibility()
        if !@model.isNew() || forceModelReset
          @model = new AnnotationModel({asset_id: @asset.id})
          @render()

    updateButtonVisibility: () ->
      if @inputPointer != null
        @ui.annotationCreateCancelButton.show()
        @ui.canvasSelectButton.show()
        @ui.canvasEraseButton.show()
      else
        @ui.annotationCreateCancelButton.hide()
        @ui.canvasSelectButton.hide()
        @ui.canvasEraseButton.hide()

    onUserFocus: (event) ->
      @startAnnotationInput()

    onUserTyping: () ->
      @startAnnotationInput()

    setCanvasMode: (mode) ->
      @startAnnotationInput()
      @vent.trigger('request:annotation:canvas:setmode', mode)

    onSetCanvasModeSelect: () ->
      @setCanvasMode('select')

    onSetCanvasModeDraw: () ->
      @setCanvasMode('draw')

    onSetCanvasModeErase: () ->
      @setCanvasMode('erase')

    onSetCanvasModeOval: () ->
      @setCanvasMode('oval')

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
      @ui.canvasSelectButton.removeClass('active')
      if activeTool == 'draw'
        @ui.canvasDrawButton.addClass('active')
      if activeTool == 'oval'
        @ui.canvasOvalButton.addClass('active')
      if activeTool == 'erase'
        @ui.canvasEraseButton.addClass('active')
      if activeTool == 'select'
        @ui.canvasSelectButton.addClass('active')

    hideVisualAnnotationUi: () ->
      @ui.canvasEraseButton.hide()
      @ui.canvasDrawButton.hide()
      @ui.canvasOvalButton.hide()

    isDirty: () ->
      @ui.annotationInput.val().length > 0 or @canvasIsDirty == true

    onRender: () ->
      @updateButtonVisibility()

    onShow: () ->
      @updateButtonVisibility()
      if !@asset.allowsVisibleAnnotation()
        @hideVisualAnnotationUi()
