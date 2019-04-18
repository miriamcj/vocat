define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/error/application_error')

  class ApplicationError extends Marionette.ItemView

    template: template

    serializeData: () ->
      {
        errorDetails: @errorDetails
      }

    sendNotification: () ->
      deferred = $.Deferred()
      $.ajax({
        url: "/api/v1/configuration"
        method: 'get'
        success: (data) =>
          deferred.resolve(data)
      })
      deferred.done((vocatConfig) =>
        if vocatConfig? && vocatConfig.notification && vocatConfig.notification.slack? && vocatConfig.notification.slack.enabled == true
          payload = {
            channel: vocatConfig.notification.slack.channel
            text: '*Rats and Dogs!*\n\nA Vocat user experienced a client side error.'
            username: "vocat-javascript-exception"
            icon_emoji: ":ghost:"
            attachments: [
              {
                fallback: 'Vocat Clientside Error'
                title: 'Error Details'
                fields: [
                  {
                    title: 'HREF'
                    value: window.location.href
                    short: false
                  }
                  {
                    title: 'Description'
                    value: @errorDetails.description
                    short: false
                  }
                  {
                    title: 'Code'
                    value: @errorDetails.code
                    short: false
                  }
                ]
              }
            ]
          }

          $.ajax({
            url: vocatConfig.notification.slack.webhook_url
            method: 'post'
            data: {
              payload: JSON.stringify(payload)
            }
          })
      )


    initialize: (options) ->
      @errorDetails = Marionette.getOption(@, 'errorDetails')
      @sendNotification()
