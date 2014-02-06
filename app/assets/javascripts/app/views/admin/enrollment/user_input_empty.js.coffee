define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment/user_input_empty')
  UserModel = require('models/user')

  class UserEnrollmentInputEmpty extends Marionette.ItemView

    template: template
    tagName: 'li'

    inviteEmail: null

    ui: {
      notFoundMessage: '[data-behavior="not_found"]'
      inviteMessage: '[data-behavior="invite"]'
      inviteTrigger: '[data-behavior="invite_trigger"]'
    }

    triggers: {
      'click [data-behavior="invite_trigger"]': 'invite'
    }

    onInvite: (options) ->
      @ui.inviteTrigger.addClass('loading')
      endpoint = '/api/v1/users/invite'
      $.ajax(endpoint, {
        type: 'POST'
        dataType: 'json'
        data: {email: @inviteEmail}
        success: (data, textStatus, jqXHR) =>
          @ui.inviteTrigger.removeClass('loading')
          @model = new UserModel(data)
          @trigger('add', @model)
          @trigger('invited')
        error: (jqXHR, textStatus, error) =>
          @ui.inviteTrigger.removeClass('loading')
          @options.vent.trigger('error:add', {level: 'error', lifetime: 5000, msg: jqXHR.responseJSON.errors})
      })

    initialize: (options) ->
      @listenTo(options.inputVent, 'input:changed', (data) =>
        email = data.value
        if @validEmail(email)
          @setInviteEmail(email)
          @ui.inviteMessage.show()
        else
          @inviteEmail = null
          @ui.inviteMessage.hide()
      )

    setInviteEmail: (email) ->
      @inviteEmail = email.toLowerCase().trim()
      @ui.inviteTrigger.html(@triggerTemplate.replace('{email}',email))

    validEmail: (email) ->
      if /.+@.+/.test(email.trim())
        true
      else
        false

    onRender: () ->
      @triggerTemplate = @ui.inviteTrigger.data().template
      @triggerLoadingTemplate = @ui.inviteTrigger.data().templateLoading


