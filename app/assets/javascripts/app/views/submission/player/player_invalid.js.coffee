define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/player/player_invalid')
  ModalConfirmView = require('views/modal/modal_confirm')

  class PlayerInvalid extends Marionette.Layout

    template: template

    triggers: {
      'click [data-behavior="destroy"]': 'video:destroy'
    }

    ui: {
      player: '[data-behavior="video-player"]'
    }

    onVideoDestroy: () ->
      @model.destroyVideo()
      @vent.triggerMethod('video:destroyed')

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @video = @model.video
      @message = options.message

    serializeData: () ->
      {
      message: @message
      }