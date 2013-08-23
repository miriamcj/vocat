define ['marionette', 'hbs!templates/rubric/fields_item', 'views/modal/modal_confirm'], (Marionette, template, ModalConfirmView) ->

  class FieldsItem extends Marionette.ItemView

    template: template

    ui: {
      nameInput: '[data-behavior="name"]'
    }

    tagName: 'li'

    triggers: {
      'click [data-behavior="destroy"]': 'model:destroy'
    }

    events: {
      'keyup [data-behavior="name"]': 'nameKeyPressed'
    }

    nameKeyPressed: (e) ->
      @onModelNameUpdate()

    onModelNameUpdate: () ->
      @model.set('name', @ui.nameInput.val())

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