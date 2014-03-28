define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment/invite')

  class Invite extends Marionette.ItemView

    template: template

    ui: {
      button: '[data-behavior="submit-invite-and-enroll"]'
      input: '[data-behavior="contact"]'
    }

    triggers: {
      'click [data-behavior="cancel-invite-and-enroll"]': 'cancel'
      'click [data-behavior="submit-invite-and-enroll"]': 'submit'
    }

    onCancel: () ->
      @ui.input.val('')


    onSubmit: () ->
      contact_string = @ui.input.val()
      @ui.button.addClass('loading')
      if @collection.searchType() == 'user'
        endpoint = @collection.bulkUrl()
      console.log endpoint,'ep'
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
      @vent = options.vent

    serializeData: () ->
      out = {
        showInput: @showInput
        contacts: @contacts
      }
      out
