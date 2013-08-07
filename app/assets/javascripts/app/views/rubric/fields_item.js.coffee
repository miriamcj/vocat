define ['marionette', 'hbs!templates/rubric/fields_item'], (Marionette, template) ->

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
      @model.destroy()

    initialize: (options) ->
      @vent = options.vent