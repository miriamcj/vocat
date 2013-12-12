define (require) ->

  Marionette =            require('marionette')
  template =              require('hbs!templates/admin/enrollment_layout')
  EnrollmentList =        require('views/admin/enrollment/list')
  EnrollmentInput =       require('views/admin/enrollment/input')
  Flash = require('views/flash/flash_messages')

  class CreatorEnrollment extends Marionette.Layout

    listType: 'users'
    template: template

    ui: {
      studentInput: '[data-behavior="student-input"]'
    }

    regions: {
      input: '[data-region="input"]'
      list: '[data-region="list"]'
      flash: '[data-region="flash"]'
    }

    initialize: (options) ->

      searchCollection = @collection.getSearchCollection()
      @enrollmentInput = new EnrollmentInput({collection: searchCollection, vent: @})
      @enrollmentList = new EnrollmentList({collection: @collection, vent: @})
      @flashView = new Flash({vent: @, clearOnAdd: true})

      # Send a post to the server to save the enrollment.
      @listenTo(@enrollmentInput, 'itemview:add', (itemView) =>
       @handleItemViewAdd(itemView)
      )

    handleItemViewAdd: (itemView) ->
      enrollment = @collection.newEnrollmentFromSearchModel(itemView.model)
      console.log enrollment,'enrollment'
      enrollment.save({},{
        error: (model, xhr) =>
          @trigger('error:add', {level: 'error', lifetime: 5000, msg: xhr.responseJSON.errors})
        success: () =>
          @collection.add(enrollment)

          @trigger('error:add', {level: 'notice', lifetime: 5000, msg: "#{enrollment.get('user_name')} is now enrolled in section ##{enrollment.get('section')}."})
      })

    onRender: () ->
      @list.show(@enrollmentList)
      @input.show(@enrollmentInput)
      @flash.show(@flashView)
