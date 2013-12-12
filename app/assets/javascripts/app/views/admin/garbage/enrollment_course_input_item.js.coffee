define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment_course_input_item')

  class EnrollmentUserInputItem extends Marionette.ItemView

    template: template
    tagName: 'li'

    triggers: () ->
      'click': 'click'

    onClick: () ->
      @trigger('add', @model)

    initialize: () ->

    onRender: () ->
