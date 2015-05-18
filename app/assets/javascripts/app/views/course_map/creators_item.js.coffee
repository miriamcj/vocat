define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/course_map/creators_item')
  ModalGroupMembershipView = require('views/modal/modal_group_membership')

  class CourseMapCreatorsItem extends Marionette.ItemView

    tagName: 'tr'

    template: template

    ui: {
      openGroupModal: '[data-behavior="open-group-modal"]'
    }

    triggers: {
      'click @ui.openGroupModal': 'open:groups:modal'
      'mouseover [data-behavior="creator-name"]': 'active'
      'mouseout [data-behavior="creator-name"]': 'inactive'
      'click [data-behavior="creator-name"]': 'detail'
    }

    attributes: {
      'data-behavior': 'navigate-creator'
    }

    serializeData: () ->
      data = super()
      if @creatorType == 'Group'
        data.isGroup = true
        data.isUser = false
      if @creatorType == 'User'
        data.isGroup = false
        data.isUser = true
      data.courseId = @options.courseId
      data.userCanAdministerCourse = window.VocatUserCourseAdministrator
      data

    onOpenGroupsModal: () ->
      Vocat.vent.trigger('modal:open', new ModalGroupMembershipView({groupId: @model.id}))

    onDetail: () ->
      @vent.triggerMethod('navigate:creator', {creator: @model.id})

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @creatorType = Marionette.getOption(@, 'creatorType')

      if @creatorType == 'Group'
        @$el.addClass('matrix--group-title')

      @listenTo(@vent, 'row:active', (data) ->
        if data.creator == @model then @$el.addClass('active')
      )

      @listenTo(@vent, 'row:inactive', (data) ->
        if data.creator == @model then @$el.removeClass('active')
      )

      @listenTo(@model.collection, 'change:active', (activeCreator) ->
        if activeCreator == @model
          @$el.addClass('selected')
          @$el.removeClass('active')
        else
          @$el.removeClass('selected')
      )
      @$el.attr('data-creator', @model.id)
