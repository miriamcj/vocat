define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment/confirm_invite')
  GlobalNotification = require('behaviors/global_notification')

  class ConfirmInvite extends Marionette.ItemView

    template: template

    klass: 'confirmInvite'

    ui: {
      button: '[data-behavior="submit-invite-and-enroll"]'
    }

    triggers: {
      'click [data-behavior="cancel-invite-and-enroll"]': 'cancel'
      'click [data-behavior="submit-invite-and-enroll"]': 'submit'
    }

    behaviors: {
      globalNotification: {
        behaviorClass: GlobalNotification
      }
    }

    onCancel: () ->
      Vocat.vent.trigger('notification:empty')

    onSubmit: () ->
      contact_strings = new Array
      _.each(@contacts, (contact) ->
        contact_strings.push(contact.string)
      )
      contact_string = contact_strings.join("\n")
      @ui.button.addClass('loading')
      if @collection.searchType() == 'user'
        endpoint = @collection.bulkUrl()
      $.ajax(endpoint, {
        type: 'POST'
        dataType: 'json'
        headers: {
          Authorization: "Bearer #{window.VocatAccessToken}"
        }
        data: {contacts: contact_string, invite: true}
        success: (data, textStatus, jqXHR) =>
          @handleSubmitSuccess(jqXHR.responseJSON)
        error: (jqXHR, textStatus, error) =>
          Vocat.vent.trigger('error:add', {level: 'error', lifetime: 5000, msg: jqXHR.responseJSON.errors})
          @ui.button.removeClass('loading')
          @onCancel()
      })

    handleSubmitSuccess: (response) ->
      @ui.button.removeClass('loading')
      successes = []
      failures = []
      _.each(response, (contact) =>
          if contact.success == true
            successes.push contact
          else
            failures.push contact
      )

      @collection.fetch()
      @onCancel()

      Vocat.vent.trigger('error:add', {level: 'notice', lifetime: 10000, msg: _.pluck(successes, 'message')})
      Vocat.vent.trigger('error:add', {level: 'error', lifetime: 10000, msg: _.pluck(failures, 'message')})

    initialize: (options) ->
      @contacts = options.contacts
      @vent = options.vent

    serializeData: () ->
      out = {
        contact_emails: _.pluck(@contacts, 'email').join(', ')
        contacts_count: @contacts.length
        multiple_contacts: @contacts.length > 1
        contacts: @contacts
      }
      out
