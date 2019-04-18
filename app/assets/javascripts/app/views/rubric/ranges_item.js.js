define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/rubric/ranges_item')
  LongTextInputView = require('views/property_editor/long_text_input')
  ModalConfirmView = require('views/modal/modal_confirm')

  class RangesItem extends Marionette.ItemView

    template: template
    className: 'cell'

    triggers: {
      'click [data-behavior="destroy"]': 'description:clear'
      'click [data-behavior="edit"]': 'click:edit'
    }

    findModel: () ->
      cells = @rubric.get('cells')
      model = cells.findWhere({field: @criteria.get('id'), range: @range.get('id')})
      model

    cellName: () ->
      @rubricName = "#{@model.rangeModel.get('name')} #{@model.fieldModel.get('name')}"

    serializeData: () ->
      data = super()
      data.rangeName = @model.rangeModel.get('name') if @model.rangeModel?
      data.fieldName = @model.fieldModel.get('name') if @model.fieldModel?
      data.cellName = @cellName()
      data

    onDescriptionClear: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Clear description?',
        confirmEvent: 'confirm:description:clear',
        dismissEvent: 'dismiss:description:clear'
      }))

    onConfirmDescriptionClear: () ->
      @model.unset('description')

    onClickEdit: () ->
      @openModal()

    openModal: () ->
      label = "Description: #{@model.rangeModel.get('name')} #{@model.fieldModel.get('name')}"
      Vocat.vent.trigger('modal:open', new LongTextInputView({
        model: @model,
        inputLabel: label,
        saveLabel: 'Update Description',
        saveClasses: 'update-button',
        property: 'description',
        vent: @vent
      }))

    initialize: (options) ->
      @vent = options.vent
      @range = options.range
      @criteria = @model
      @rubric = options.rubric
      @model = @findModel()

      if @model?
        @listenTo(@model, 'change', () ->
          @render()
        )
      @listenTo(@model.rangeModel, 'change:name', @render, @) if @model.rangeModel?
      @listenTo(@model.fieldModel, 'change:name', @render, @) if @model.fieldModel?
