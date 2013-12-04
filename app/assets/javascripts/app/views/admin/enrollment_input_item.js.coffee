define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment_input_item')

  class EnrollmentInputItem extends Marionette.ItemView

    template: template
    tagName: 'li'

    triggers: () ->
      'click': 'click'

    onClick: () ->
      @trigger('add', @model)

    initialize: () ->

    onRender: () ->
