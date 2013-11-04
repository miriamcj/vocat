define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/rubric/cell')
  LongTextInputView = require('views/property_editor/long_text_input')

  class Cell extends Marionette.ItemView

    template: template

    tagName: 'li'
    className: 'matrix--cell'

    onShow: () ->
      @$el.on( 'click', (event) =>
        @triggerMethod('open:modal')
      )

    initialize: (options) ->
      @vent = Vocat.vent
      @listenTo(@model,'change', () =>
        @render()
      )
      @listenTo(@model.rangeModel, 'change:name', @render, @) if @model.rangeModel?
      @listenTo(@model.fieldModel, 'change:name', @render, @) if @model.fieldModel?

    serializeData: () ->
      data = super()
      data.rangeName = @model.rangeModel.get('name') if @model.rangeModel?
      data.fieldName = @model.fieldModel.get('name') if @model.fieldModel?
      data

    onOpenModal: () ->
      label = "#{@model.rangeModel.get('name')} #{@model.fieldModel.get('name')} description"
      @vent.trigger('modal:open', new LongTextInputView({model: @model, inputLabel: label, property: 'description', vent: @vent}))