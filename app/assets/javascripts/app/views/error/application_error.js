/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'backbone.marionette';
import template from 'templates/error/application_error.hbs';

export default class ApplicationError extends Marionette.ItemView {
  constructor() {

    this.template = template;
  }

  serializeData() {
    return {
      errorDetails: this.errorDetails
    };
  }

  sendNotification() {
    const deferred = $.Deferred();
    $.ajax({
      url: "/api/v1/configuration",
      method: 'get',
      success: data => {
        return deferred.resolve(data);
      }
    });
    return deferred.done(vocatConfig => {
      if ((vocatConfig != null) && vocatConfig.notification && (vocatConfig.notification.slack != null) && (vocatConfig.notification.slack.enabled === true)) {
        const payload = {
          channel: vocatConfig.notification.slack.channel,
          text: '*Rats and Dogs!*\n\nA Vocat user experienced a client side error.',
          username: "vocat-javascript-exception",
          icon_emoji: ":ghost:",
          attachments: [
            {
              fallback: 'Vocat Clientside Error',
              title: 'Error Details',
              fields: [
                {
                  title: 'HREF',
                  value: window.location.href,
                  short: false
                },
                {
                  title: 'Description',
                  value: this.errorDetails.description,
                  short: false
                },
                {
                  title: 'Code',
                  value: this.errorDetails.code,
                  short: false
                }
              ]
            }
          ]
        };

        return $.ajax({
          url: vocatConfig.notification.slack.webhook_url,
          method: 'post',
          data: {
            payload: JSON.stringify(payload)
          }
        });
      }
    });
  }


  initialize(options) {
    this.errorDetails = Marionette.getOption(this, 'errorDetails');
    return this.sendNotification();
  }
};
