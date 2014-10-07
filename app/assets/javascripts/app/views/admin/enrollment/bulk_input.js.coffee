define (require) ->

  Marionette = require('marionette')
  require('jquery_ui')
  require('vendor/plugins/ajax_chosen')
  ConfirmInvite =   require('views/admin/enrollment/confirm_invite')
  template = require('hbs!templates/admin/enrollment/bulk_input')

  class EnrollmentBulkInput extends Marionette.LayoutView

    ui: {
      showSingle: '[data-behavior="show-single"]'
      bulkInput: '[data-behavior="bulk-input"]'
      submit: '[data-behavior="submit"]'
    }

    triggers: {
      'click [data-behavior="show-single"]': 'showSingle'
      'click [data-behavior="submit"]': 'submit'
    }

    regions: {
      confirmInvite: '[data-region="confirm-invite"]'
    }


    initialize: (options) ->
      @vent = options.vent

    onSubmit: () ->
      @ui.submit.addClass('loading')
      contacts = @ui.bulkInput.val()
      if @collection.searchType() == 'user'
        endpoint = @collection.bulkUrl()
      $.ajax(endpoint, {
        type: 'POST'
        dataType: 'json'
        data: {contacts: contacts, invite: false}
        success: (data, textStatus, jqXHR) =>
          @handleSubmitSuccess(jqXHR.responseJSON)
        error: (jqXHR, textStatus, error) =>
          @ui.submit.removeClass('loading')
          Vocat.vent.trigger('error:add', {level: 'error', lifetime: 5000, msg: jqXHR.responseJSON.errors})
      })

    showInviteMustConfirm: (contacts) ->
      Vocat.globalNotify.show(new ConfirmInvite({collection: @collection, contacts: contacts, vent: @vent}))

    handleSubmitSuccess: (response) ->
      @ui.submit.removeClass('loading')
      confirm = []
      failures = []
      successes = []
      strings = []
      _.each(response, (contact) =>
        if contact.success == true
          successes.push contact
        else if contact.success == false && contact.reason == 'must_confirm'
          strings.push contact.string
          confirm.push contact
        else
          strings.push contact.string
          failures.push contact
      )
      Vocat.vent.trigger('error:add', {level: 'notice', lifetime: 10000, msg: _.pluck(successes, 'message')})
      Vocat.vent.trigger('error:add', {level: 'error', lifetime: 10000, msg: _.pluck(failures, 'message')})

      inputValue = strings.join("\n")
      @ui.bulkInput.val(inputValue)

      if confirm.length > 0
        @showInviteMustConfirm(confirm)

      @collection.fetch()

    template: template