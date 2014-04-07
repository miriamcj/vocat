define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment/confirm_invite')

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

    onCancel: () ->
      @close()

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
        data: {contacts: contact_string, invite: true}
        success: (data, textStatus, jqXHR) =>
          @handleSubmitSuccess(jqXHR.responseJSON)
        error: (jqXHR, textStatus, error) =>
          @vent.trigger('error:add', {level: 'error', lifetime: 5000, msg: jqXHR.responseJSON.errors})
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
      @vent.trigger('error:add', {level: 'notice', lifetime: 10000, msg: _.pluck(successes, 'message')})
      @vent.trigger('error:add', {level: 'error', lifetime: 10000, msg: _.pluck(failures, 'message')})
      @collection.fetch()
      @onCancel()

    initialize: (options) ->
      @contacts = options.contacts
      @vent = options.vent

    serializeData: () ->
      out = {
        contacts: @contacts
      }
      out