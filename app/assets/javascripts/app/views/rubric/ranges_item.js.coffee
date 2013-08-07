define ['marionette', 'hbs!templates/rubric/ranges_item'], (Marionette, template) ->

  class RangesItem extends Marionette.ItemView

    template: template

    tagName: 'li'

    ui: {
      nameInput: '[data-behavior="name"]'
      lowRange: '[data-behavior="low"]'
      highRange: '[data-behavior="high"]'
    }

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

    updateLowRange: () ->
      @ui.lowRange.html(@model.get('low'))

    updateHighRange: () ->
      @ui.highRange.html(@model.get('high'))


    initialize: (options) ->
      @vent = options.vent

      @listenTo(@model, 'change:low', (range) =>
        @updateLowRange()
      )

      @listenTo(@model, 'change:high', (range) =>
        @updateHighRange()
      )
