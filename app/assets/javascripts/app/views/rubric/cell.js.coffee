define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/rubric/cell')
  LongTextInputView = require('views/property_editor/long_text_input')

  class Cell extends Marionette.ItemView

    template: template

    tagName: 'td'
    className: 'wrap-cell rubric-cell'

    onShow: () ->
      @$el.on('click', (event) =>
        @triggerMethod('open:modal')
      )

    initialize: (options) ->
      @vent = Vocat.vent
      @range = @model
      @field = options.field
      @rubric = options.rubric
      @model = @findModel()

      if @model?
        @listenTo(@model, 'change', () ->
          @render()
        )
      @listenTo(@model.rangeModel, 'change:name', @render, @) if @model.rangeModel?
      @listenTo(@model.fieldModel, 'change:name', @render, @) if @model.fieldModel?

    findModel: () ->
      cells = @rubric.get('cells')
      model = cells.findWhere({field: @field.get('id'), range: @range.get('id')})
      model

    serializeData: () ->
      data = super()
      data.rangeName = @model.rangeModel.get('name') if @model.rangeModel?
      data.fieldName = @model.fieldModel.get('name') if @model.fieldModel?
      data

    onOpenModal: () ->
      label = "Description: #{@model.rangeModel.get('name')} #{@model.fieldModel.get('name')}"
      @vent.trigger('modal:open', new LongTextInputView({
        model: @model,
        inputLabel: label,
        saveLabel: 'Update Description',
        saveClasses: 'update-button',
        property: 'description',
        vent: @vent
      }))
