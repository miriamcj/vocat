define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/annotator/annotator')
  ProgressBarView = require('views/assets/annotator/progress_bar')
  AnnotationInputView = require('views/assets/annotator/annotator_input')
  AnnotationModel = require('models/annotation')
  ModalConfirmView = require('views/modal/modal_confirm')

  class AnnotatorView extends Marionette.LayoutView

    template: template
    hideProgressBar: false

    regions: {
      progressBar: '[data-behavior="progress-bar"]'
      annotationInput: '[data-region="annotator-input"]'
    }

    ui: {
    }

    setupListeners: () ->
      @listenTo(@vent,'request:annotator:save', @saveAnnotation, @)
      @listenTo(@collection,'destroy', @handleAnnotationDestruction, @)

    saveAnnotation: (annotation, properties) ->
      @listenToOnce(@vent, 'announce:status', (response) =>
        @listenToOnce(@vent, 'announce:canvas', (canvas) =>
          secondsTimecode = response.playedSeconds;
          properties['canvas'] = canvas
          properties['published'] = true
          properties['seconds_timecode'] = secondsTimecode
          annotation.save(properties, {
              success: (annotation) => @handleAnnotationSaveSuccess(annotation)
              error: (annotation, xhr) => @handleAnnotationSaveError(annotation, xhr)
            }
          )
        )
        @vent.trigger('request:canvas', {})
      )
      @vent.trigger('request:status', {})

    handleAnnotationSaveSuccess: (annotation) ->
      @collection.add(annotation, {merge: true})
      annotation.activate()
      @vent.trigger('request:status', {})

    handleAnnotationSaveError: (annotation, xhr) ->
      Vocat.vent.trigger('error:add', {level: 'error', clear: true, msg: xhr.responseJSON.errors})

    handleAnnotationDestruction: (annotation) ->
      if @annotationInput.currentView.model == annotation
        @vent.trigger('request:annotator:input:reset')

    initialize: (options) ->
      @vent = options.vent
      @collection = @model.annotations()
      window.zd = @collection
      @setupListeners()

    onShow: () ->
      if @model.hasDuration()
        @progressBar.show(new ProgressBarView({model: @model, vent: @vent, collection: @collection}))
      else
        $(@progressBar.el).hide()
      @annotatorInputView = new AnnotationInputView({asset: @model, model: new AnnotationModel({asset_id: @model.id}), vent: @vent, collection: @collection})
      @annotationInput.show(@annotatorInputView)
