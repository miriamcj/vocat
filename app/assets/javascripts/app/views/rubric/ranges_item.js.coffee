define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/rubric/ranges_item')
  ModalConfirmView = require('views/modal/modal_confirm')
  ShortTextInputView = require('views/property_editor/short_text_input')

  class RangesItem extends Marionette.ItemView

    template: template

    tagName: 'li'

    ui: {
      lowRange: '[data-behavior="low"]'
      highRange: '[data-behavior="high"]'
    }

    triggers: {
      'click [data-behavior="destroy"]': 'model:destroy'
      'click [data-behavior="edit"]': 'click:edit'
    }

    events: {
      'keyup [data-behavior="name"]': 'nameKeyPressed'
    }

    onModelDestroy: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Deleting this range will also delete all descriptions associated with this range. Are you sure you want to do this?',
        confirmEvent: 'confirm:model:destroy',
        dismissEvent: 'dismiss:model:destroy'
      }))

    onClickEdit: () ->
      @openModal()

    openModal: () ->
      Vocat.vent.trigger('modal:open', new ShortTextInputView({model: @model, property: 'name', inputLabel: 'What would you like to call this range?', vent: @vent}))

    onConfirmModelDestroy: () ->
      @model.destroy()

    updateLowRange: () ->
      @ui.lowRange.html(@model.get('low'))

    updateHighRange: () ->
      @ui.highRange.html(@model.get('high'))

    initialize: (options) ->
      @vent = options.vent
      @listenTo(@model, 'change', @render, @)
      @listenTo(@model, 'edit', @openModal, @)
