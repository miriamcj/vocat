define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/annotator/video_annotator')
  VideoProgressBarView = require('views/assets/annotator/video_progress_bar')
  AnnotationInputView = require('views/assets/annotator/annotator_input')
  AnnotationModel = require('models/annotation')
  ModalConfirmView = require('views/modal/modal_confirm')

  class VideoAnnotatorView extends Marionette.LayoutView

    template: template

    regions: {
      progressBar: '[data-behavior="progress-bar"]'
      annotationInput: '[data-region="annotator-input"]'
    }

    setupListeners: () ->
      @listenTo(@vent, 'edit:annotation', (annotation) ->
        @handleEditAnnotationRequest(annotation)
      )
      @listenTo(@vent, 'annotator:refresh', () ->
        @showAnnotationNewInput()
      )

    handleEditAnnotationRequest: (annotation) ->
      if @annotationInput.currentView.model == annotation
        Vocat.vent.trigger('error:add', {level: 'notice', lifetime: '3000',  msg: 'You are already editing this annotation'})
      else if @annotationInput.currentView.isDirty()
        Vocat.vent.trigger('modal:open', new ModalConfirmView({
          model: annotation,
          vent: @,
          descriptionLabel: 'It looks like you have unsaved text in the annotator. If you proceed, this text will be lost.',
          confirmEvent: 'confirm:show:edit',
          dismissEvent: 'dismiss:show:edit'
        }))
      else
        @showAnnotationEditInput(annotation)

    onConfirmShowEdit: (annotation) ->
      @showAnnotationEditInput(annotation)

    showAnnotationNewInput: () ->
      @annotationInput.show(new AnnotationInputView({asset: @model, model: new AnnotationModel({asset_id: @model.id}), vent: @vent, collection: @collection}))

    showAnnotationEditInput: (annotation) ->
      @annotationInput.show(new AnnotationInputView({asset: @model, model: annotation, vent: @vent, collection: @collection}))

    initialize: (options) ->
      @vent = options.vent
      @collection = @model.annotations()
      @setupListeners()

    onShow: () ->
      @progressBar.show(new VideoProgressBarView({model: @model, vent: @vent, collection: @collection}))
      @showAnnotationNewInput()