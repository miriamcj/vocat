define [
  'marionette',
  'hbs!templates/notification/notification_message',
], (Marionette, template) ->
  class NotificationMessage extends Marionette.ItemView

    template: template
    lifetime: 10000
    isFlash: true

    triggers: {
      'click [data-behavior="close-message"]': 'closeMessage'
    }

    onCloseMessage: () ->
      @trigger('view:expired')

    className: () ->
      "alert alert-#{@model.get('level')}"

    initialize: (options) ->
      lifetime = parseInt(@model.get('lifetime'))
      @lifetime = lifetime if lifetime > 0

    onShow: ->
      setTimeout(() =>
        @trigger('view:expired')
      , @lifetime
      )

