define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/rubric/criteria_item')
  ShortTextInputView = require('views/property_editor/short_text_input')
  ModalConfirmView = require('views/modal/modal_confirm')

  class CriteriaItem extends Marionette.ItemView

    template: template
    className: 'criteria-item'

    triggers: {
      'click [data-behavior="destroy"]': 'model:destroy'
      'click [data-behavior="edit"]': 'click:edit'
      'click [data-behavior="move-up"]': 'click:up'
      'click [data-behavior="move-down"]': 'click:down'
    }

    openModal: () ->
      label = "What would you like to call this criteria?"
      Vocat.vent.trigger('modal:open', new ShortTextInputView({
        model: @model,
        inputLabel: label,
        saveLabel: 'Update Criteria Name',
        saveClasses: 'update-button',
        property: 'name',
        vent: @vent
      }))

    onModelDestroy: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Deleting this criteria will also delete all descriptions associated with this criteria.',
        confirmEvent: 'confirm:model:destroy',
        dismissEvent: 'dismiss:model:destroy'
      }))

    onClickEdit: () ->
      @openModal()

    onClickUp: () ->
      @collection.comparator = 'index'
      @nextModel = @collection.at(@model.get('index') - 1)
      unless @collection.indexOf(@model) == 0
        @model.set('index', @model.get('index') - 1)
        @nextModel.set('index', @model.get('index') + 1)
        @collection.sort()

    onClickDown: () ->
      @collection.comparator = 'index'
      @nextModel = @collection.at(@model.get('index') + 1)
      unless @model.index == @collection.length - 1
        @model.set('index', @model.get('index') + 1)
        @nextModel.set('index', @model.get('index') - 1)
        @collection.sort()

    onConfirmModelDestroy: () ->
      @collection.remove(@model)
      @model.destroy()

    initialize: () ->
      @listenTo(@model, 'change:name', @render, @)
