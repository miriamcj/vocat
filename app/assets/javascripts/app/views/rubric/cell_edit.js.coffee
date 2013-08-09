define ['marionette', 'hbs!templates/rubric/cell_edit'], (Marionette, template) ->

  class CellEditView extends Marionette.ItemView

    template: template

    ui: {
      descriptionInput: '[data-property="description"]'
    }

    triggers: {
      'click [data-behavior="model-save"]': 'click:model:save'
    }

    onClickModelSave: () ->
      @save()

    save: () ->
      @model.set('description', @ui.descriptionInput.val())
      Vocat.vent.trigger('modal:close')

    initialize: (options) ->
      @vent = options.vent
