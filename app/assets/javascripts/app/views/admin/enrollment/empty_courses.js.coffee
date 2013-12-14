define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment/empty_courses')

  class EnrollmentEmptyCourses extends Marionette.ItemView

    template: template
    tagName: 'tr'

    serializeData: () ->
      {
        colspan: 4
      }

    onShow: () ->
      console.log @
      @$el.find('th').attr('colspan', @$el.closest('table').find('thead th').length)
