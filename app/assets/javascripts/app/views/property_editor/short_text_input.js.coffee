define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/property_editor/short_text_input')

  class ShortTextInput extends Marionette.ItemView

    template: template

    ui: {
      input: '[data-property="input"]'
      errorContainer: '[data-behavior="error-container"]'
    }

    saveModelOnSave: false
    onSave: null
    inputLabel: 'Update Property'

    triggers: {
      'click [data-behavior="model-save"]': 'click:model:save'
      'click [data-behavior="cancel"]': 'click:model:cancel'
    }

    onClickModelCancel: () ->
      Vocat.vent.trigger('modal:close')

    onClickModelSave: () ->
      @save()
      if _.isFunction(@onSave)
        @onSave()

    getValue: () ->
      @ui.input.val()

    save: () ->
      attr = {}
      attr[@property] = @getValue()

      # Save or set
      if Marionette.getOption(@, "saveModelOnSave") == true
        @model.save(attr, {validate: true})
      else
        @model.set(attr, {validate: true})

      # Check if valid
      if @model.isValid()
        Vocat.vent.trigger('modal:close')
        @trigger('model:updated')
      else
        error = @model.validationError
        @updateError(error)

    updateError: (error) ->
      @ui.errorContainer.html(error)
      @ui.errorContainer.show()

    initialize: (options) ->
      @property = options.property
      @vent = options.vent
      @onSave = Marionette.getOption(@, "onSave")


    serializeData: () ->
      {
      value: @model.get(@property)
      label: Marionette.getOption(@, "inputLabel")
      saveClasses: Marionette.getOption(@, "saveClasses")
      saveLabel: Marionette.getOption(@, "saveLabel")
      }

    onRender: () ->
      input = @$el.find('[data-property="input"]')
      setTimeout(() ->
        input.focus()
      , 0)

