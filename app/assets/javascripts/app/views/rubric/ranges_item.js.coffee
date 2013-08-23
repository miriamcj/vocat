define ['marionette', 'hbs!templates/rubric/ranges_item', 'views/modal/modal_confirm'], (Marionette, template, ModalConfirmView) ->

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
      console.log 'called'
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Deleting this range will also delete all descriptions associated with this range. Are you sure you want to do this?',
        confirmEvent: 'confirm:model:destroy',
        dismissEvent: 'dismiss:model:destroy'
      }))

    onConfirmModelDestroy: () ->
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
