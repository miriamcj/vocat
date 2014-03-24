define (require) ->

  Marionette =            require('marionette')
  template =              require('hbs!templates/admin/enrollment_layout')
  EnrollmentList =        require('views/admin/enrollment/list')
  EnrollmentInput =       require('views/admin/enrollment/input')
  EnrollmentBulkInput =   require('views/admin/enrollment/bulk_input')
  SingleInvite = require('views/admin/enrollment/invite')
  Flash = require('views/flash/flash_messages')

  class CreatorEnrollmentLayout extends Marionette.Layout

    listType: 'users'
    template: template

    ui: {
      studentInput: '[data-behavior="student-input"]'
    }

    regions: {
      input: '[data-region="input"]'
      list: '[data-region="list"]'
      invite: '[data-region="invite"]'
      flash: '[data-region="flash"]'
    }

    # Collection for this view is an enrollment collection, created by the controller.
    initialize: (options) ->
      # The search collection contains the results of the asynch search
      @searchCollection = @collection.getSearchCollection()

      # Can be courses or users, since the same UI elements are used for both.
      @searchType = @collection.searchType()

      # The list of current enrollments
      @enrollmentList = new EnrollmentList({collection: @collection, vent: @})

      # Error messages and feedback.
      @flashView = new Flash({vent: @, clearOnAdd: false})

    showBulkEnrollAndInvite: () ->
      @invite.reset()
      enrollmentBulkInput = new EnrollmentBulkInput({collection: @collection, vent: @})
      @input.show(enrollmentBulkInput)
      @listenTo(enrollmentBulkInput, 'showSingle', (event) =>
        @showSingle()
      )
      @input.show(enrollmentBulkInput)

    showSingleInvite: () ->
      singleInvite = new SingleInvite({collection: @collection, vent: @, useAltTemplate: true})
      @invite.show(singleInvite)

    showBulk: () ->
      @showBulkEnrollAndInvite()

    showSingle: () ->
      @showSingleEnroll()
      if @searchType == 'user'
        @showSingleInvite()

    showSingleEnroll: () ->
      enrollmentInput = new EnrollmentInput({collection: @searchCollection, enrollmentCollection: @collection, collectionType: @searchType, vent: @})
      @input.show(enrollmentInput)
      @listenTo(enrollmentInput, 'showBulk', (event) =>
        @showBulk()
      )
      @input.show(enrollmentInput)

    onRender: () ->
      @list.show(@enrollmentList)
      @flash.show(@flashView)
      @showSingle()
