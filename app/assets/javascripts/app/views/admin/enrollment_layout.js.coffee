define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment_layout')
  EnrollmentList = require('views/admin/enrollment_list')
  EnrollmentInput = require('views/admin/enrollment_input')
  Flash = require('views/flash/flash_messages')
  UserCollection = require('collections/user_collection')

  class CreatorEnrollment extends Marionette.Layout

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
      @enrollmentList = new EnrollmentList({collection: @collection, vent: @})
      searchCollection = @collection.clone().reset()
      searchCollection.courseId = @collection.courseId
      @enrollmentInput = new EnrollmentInput({collection: searchCollection, vent: @})
      @flashView = new Flash({vent: @, clearOnAdd: true})

      # Send a post to the server to save the user.
      @listenTo(@enrollmentInput, 'itemview:add', (itemView) ->
        modelClass = @collection.model
        newEnrollment = new modelClass(itemView.model.attributes)
        newEnrollment.courseId = @collection.courseId
        newEnrollment.save({},{
          error: (model, xhr) =>
            console.log xhr.responseJSON.errors,'errors'
            @trigger('error:add', {level: 'error', lifetime: 5000, msg: xhr.responseJSON.errors})
          success: () =>
            @collection.add(newEnrollment)
            @trigger('error:add', {level: 'notice', lifetime: 5000, msg: "#{newEnrollment.get('name')} has been added to the course."})
        })
      )

    onRender: () ->
      @list.show(@enrollmentList)
      @input.show(@enrollmentInput)
      @flash.show(@flashView)