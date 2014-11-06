define ['marionette', 'hbs!templates/course_map/creators_item'], (Marionette, template) ->

  class CourseMapCreatorsItem extends Marionette.ItemView

    tagName: 'tr'

    template: template

    triggers: {
      'mouseover [data-behavior="creator-name"]': 'active'
      'mouseout [data-behavior="creator-name"]': 'inactive'
      'click [data-behavior="creator-name"]':   'detail'
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

    onActive: () ->
      @vent.triggerMethod('row:active', {creator: @model})

    onInactive: () ->
      @vent.triggerMethod('row:inactive', {creator: @model})

    onDetail: () ->
      @vent.triggerMethod('open:detail:creator', {creator: @model})

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @creatorType = Marionette.getOption(@, 'creatorType')

      if @creatorType == 'Group'
        @$el.addClass('matrix--group-title')

      @listenTo(@vent,'row:active', (data) ->
        if data.creator == @model then @$el.addClass('active')
      )

      @listenTo(@vent,'row:inactive', (data) ->
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
