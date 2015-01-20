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

    setupListeners: () ->
      @listenTo(@vent, 'edit:annotation', (annotation) ->
        @handleEditAnnotationRequest(annotation)
      )
      @listenTo(@vent, 'annotator:refresh', () ->
        @showAnnotationNewInput()
      )

    handleEditAnnotationRequest: (annotation) ->
      if @annotationInput.currentView.model == annotation

        Vocat.vent.trigger('error:add', {level: 'notice', clear: true, lifetime: '3000',  msg: 'You are already editing this annotation'})
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
      if @model.hasDuration()
        @progressBar.show(new ProgressBarView({model: @model, vent: @vent, collection: @collection}))
      else
        $(@progressBar.el).hide()
      @showAnnotationNewInput()