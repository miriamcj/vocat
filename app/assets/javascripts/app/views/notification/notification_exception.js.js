define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/notification/notification_exception')
  GlobalNotification = require('behaviors/global_notification')

  class NotificationException extends Marionette.ItemView

    template: template

    behaviors: {
      globalNotification: {
        behaviorClass: GlobalNotification
      }
    }

    serializeData: () ->
      {
      msg: @msg
      }

    initialize: (options) ->
      @msg = options.msg
