define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/rubric/range')
  ItemView = require('views/rubric/ranges_item')
  ModalConfirmView = require('views/modal/modal_confirm')
  ShortTextInputView = require('views/property_editor/short_text_input')

  class RangeView extends Marionette.CompositeView

    template: template
    className: 'ranges-column'
    childViewContainer: '[data-id="range-cells"]'
    childView: ItemView

    ui: {
      lowRange: '[data-behavior="low"]'
      highRange: '[data-behavior="high"]'
    }

    triggers: {
      'click [data-behavior="destroy"]': 'model:destroy'
      'click [data-behavior="edit"]': 'click:edit'
      'click [data-behavior="move-left"]': 'click:left'
      'click [data-behavior="move-right"]': 'click:right'
    }

    events: {
      'keyup [data-behavior="name"]': 'nameKeyPressed'
    }

    childViewOptions: () ->
      {
        rubric: @rubric
        range: @model
        vent: @vent
      }

    onModelDestroy: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Deleting this range will also delete all descriptions associated with this range.',
        confirmEvent: 'confirm:model:destroy',
        dismissEvent: 'dismiss:model:destroy'
      }))

    onClickEdit: () ->
      @openModal()

    openModal: () ->
      Vocat.vent.trigger('modal:open', new ShortTextInputView({
        model: @model,
        property: 'name',
        saveClasses: 'update-button',
        saveLabel: 'Update Range Name',
        inputLabel: 'What would you like to call this range?',
        vent: @vent
      }))

    onConfirmModelDestroy: () ->
      @collection.remove(@model)
      @model.destroy()

    updateLowRange: () ->
      @ui.lowRange.html(@model.get('low'))

    updateHighRange: () ->
      @ui.highRange.html(@model.get('high'))

    initialize: (options) ->
      @vent = options.vent
      @rubric = options.rubric
      @collection = options.criteria

      if @model?
        @listenTo(@model, 'change', () ->
          @render()
        )
      @listenTo(@collection, 'all', (event) ->
        @render()
      )
