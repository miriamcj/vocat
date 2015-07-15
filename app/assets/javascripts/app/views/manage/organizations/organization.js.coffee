define (require) ->
  marionette = require('marionette')

  class ManageOrganizationView extends Marionette.ItemView

    template: false

    ui: {
      ldapEnabled: '[data-class="ldap-enabled"]'
      ldapFields: '[data-class="ldap-fields"]'

    }

    triggers: {
      'change @ui.ldapEnabled': 'change:ldap:enabled'
    }

    onChangeLdapEnabled: () ->
      val = @ui.ldapEnabled.val()
      if val == 'true'
        console.log 'showing'
        @ui.ldapFields.show()
      else
        console.log 'hiding'
        @ui.ldapFields.hide()


    initialize: () ->
      @render()

    onRender: (options) ->
      @onChangeLdapEnabled()

