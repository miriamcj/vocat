define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/rubric/fields_item')
  ModalConfirmView = require('views/modal/modal_confirm')
  ShortTextInputView = require('views/property_editor/short_text_input')

  class FieldsItem extends Marionette.ItemView

    template: template

    tagName: 'tr'

    triggers: {
      'click [data-behavior="destroy"]': 'model:destroy'
      'click [data-behavior="edit"]': 'click:edit'
    }

    events: {
      'keyup [data-behavior="name"]': 'nameKeyPressed'
    }

    onClickEdit: () ->
      @openModal()

    openModal: () ->
      Vocat.vent.trigger('modal:open', new ShortTextInputView({model: @model, property: 'name', inputLabel: 'What would you like to call this criteria?', vent: @vent}))

    nameKeyPressed: (e) ->
      @onModelNameUpdate()

    onModelDestroy: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Deleting this field will also delete all descriptions associated with this field. Are you sure you want to do this?',
        confirmEvent: 'confirm:model:destroy',
        dismissEvent: 'dismiss:model:destroy'
      }))

    onConfirmModelDestroy: () ->
      @model.destroy()

    initialize: (options) ->
      @vent = options.vent
      @listenTo(@model, 'change:name', @render, @)
      @listenTo(@model, 'edit', @openModal, @)
