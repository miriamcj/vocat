define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/property_editor/short_text_input')

  class ShortTextInput extends Marionette.ItemView

    template: template

    ui: {
      input: '[data-property="input"]'
    }

    saveModelOnSave: false
    onSave: null
    inputLabel: 'Update Property'

    triggers: {
      'click [data-behavior="model-save"]': 'click:model:save'
    }

    onClickModelSave: () ->
      @save()
      if _.isFunction(@onSave)
        @onSave()

    getValue: () ->
      @ui.input.val()

    save: () ->
      if Marionette.getOption(@, "saveModelOnSave") == true
        @model.save(@property, @getValue())
      else
        @model.set(@property, @getValue())
      Vocat.vent.trigger('modal:close')

    initialize: (options) ->
      @property = options.property
      @vent = options.vent
      @onSave = Marionette.getOption(@, "onSave")


    serializeData: () ->
      {
        value: @model.get(@property)
        label: Marionette.getOption(@, "inputLabel")
      }

    onRender: () ->
      input = @$el.find('[data-property="input"]')
      setTimeout(() ->
        input.focus()
      ,0)

