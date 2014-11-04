define [
  'marionette',
  'hbs!templates/notification/notification_message',
],(
  Marionette, template
) ->

  class NotificationMessage extends Marionette.ItemView

    template: template
    lifetime: 10000

    className: () ->
      "alert alert-#{@model.get('level')}"

    triggers:
      'click [data-behavior="destroy"]': 'destroy'

    initialize: (options) ->
      lifetime = parseInt(@model.get('lifetime'))
      @lifetime = lifetime if lifetime > 0

    onShow: ->
      setTimeout( () =>
        @trigger('view:expired')
      , @lifetime
      )

