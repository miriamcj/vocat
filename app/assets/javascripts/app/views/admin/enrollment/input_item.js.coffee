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
    className: 'active-result'

    initialize: (options) ->
      console.log options, 'opt'
      @enrollmentCollection = options.enrollmentCollection
      @vent = options.vent

    triggers: () ->
      'mousedown': 'click'

    onClick: () ->
      enrollment = @enrollmentCollection.newEnrollmentFromSearchModel(@model)
      enrollment.save({},{
        error: (model, xhr) =>
          Vocat.vent.trigger('error:add', {level: 'error', lifetime: 5000, msg: xhr.responseJSON.errors})
        success: () =>
          @enrollmentCollection.add(enrollment)
          @trigger('add', enrollment)
          if @enrollmentCollection == 'users'
            role = @enrollmentCollection.role()
            l = role[0]
            if l == 'a' || l == 'e' || l == 'i' || l == 'o' || l == 'u'
              article = 'an'
            else
              article = 'a'
            Vocat.vent.trigger('error:add', {level: 'notice', lifetime: 5000, msg: "#{enrollment.get('user_name')} is now #{article} #{role} in section ##{enrollment.get('section')}."})
          else
            Vocat.vent.trigger('error:add', {level: 'notice', lifetime: 5000, msg: "#{enrollment.get('user_name')} is now enrolled in section #{enrollment.get('section')}"})
      })
      @trigger('clicked')

    onRender: () ->
