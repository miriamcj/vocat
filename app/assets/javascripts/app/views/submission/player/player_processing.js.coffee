define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/player/player_processing')
  ModalConfirmView = require('views/modal/modal_confirm')

  class PlayerProcessing extends Marionette.LayoutView

    template: template

    triggers: {
      'click [data-behavior="destroy"]': 'video:destroy'
    }

    onVideoDestroy: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Deleted videos cannot be recovered. Please confirm that you would like to delete this video.',
        confirmEvent: 'confirm:destroy',
        dismissEvent: 'dismiss:destroy'
      }))

    onConfirmDestroy: () ->
      @model.destroyVideo()
      @vent.triggerMethod('video:destroyed')

    initialize: (options) ->
      @message = options.message
      @vent = Marionette.getOption(@, 'vent')

    serializeData: () ->
      {
        message: @message
        abilities: @model.get('abilities')
      }