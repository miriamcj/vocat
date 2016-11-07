define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/rubric/ranges_item')
  LongTextInputView = require('views/property_editor/long_text_input')

  class RangesItem extends Marionette.ItemView

    template: template
    className: 'cell'

    onShow: () ->
      @$el.on('click', (event) =>
        @triggerMethod('open:modal')
      )

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

    onOpenModal: () ->
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

