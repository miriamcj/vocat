define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment_input_no_results')

  class EnrollmentInputNoResults extends Marionette.ItemView

    template: template
    tagName: 'li'
