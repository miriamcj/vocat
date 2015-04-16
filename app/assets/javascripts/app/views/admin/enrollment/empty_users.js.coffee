define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment/empty_users')

  class EnrollmentEmptyUsers extends Marionette.ItemView

    template: template
    tagName: 'tr'

    serializeData: () ->
      {
      colspan: 4
      role: @options.role
      }

    onShow: () ->
      @$el.find('th').attr('colspan', @$el.closest('table').find('thead th').length)
