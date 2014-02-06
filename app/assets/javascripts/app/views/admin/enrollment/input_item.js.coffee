define (require) ->

  Marionette = require('marionette')
  courseTemplate = require('hbs!templates/admin/enrollment/course_input_item')
  userTemplate = require('hbs!templates/admin/enrollment/user_input_item')

  class EnrollmentUserInputItem extends Marionette.ItemView

    getTemplate: () ->
      if @model.get('section')?
        courseTemplate
      else
        userTemplate

    tagName: 'li'

    triggers: () ->
      'click': 'click'

    onClick: () ->
      @trigger('add', @model)

    initialize: () ->

    onRender: () ->
