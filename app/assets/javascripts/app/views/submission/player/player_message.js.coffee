define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/player/player_message')

  class PlayerMessage extends Marionette.Layout

    template: template

    initialize: (options) ->
      @message = options.message

    serializeData: () ->
      {
        message: @message
      }