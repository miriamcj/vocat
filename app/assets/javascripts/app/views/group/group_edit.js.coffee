define ['marionette', 'hbs!templates/group/group_edit'], (Marionette, template) ->

  class GroupEditView extends Marionette.ItemView

    template: template

    ui: {
      input: '[data-property="name"]'
    }

    triggers: {
      'click [data-behavior="model-save"]': 'click:model:save'
    }

    onClickModelSave: () ->
      @save()

    save: () ->
      @model.save('name', @ui.input.val())
      Vocat.vent.trigger('modal:close')

    initialize: (options) ->
      @vent = options.vent

    onRender: () ->
      setTimeout(() =>
        @ui.input.triggerHandler("focus")
      ,1000)
