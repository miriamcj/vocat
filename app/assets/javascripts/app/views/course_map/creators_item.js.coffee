define ['marionette', 'hbs!templates/course_map/creators_item'], (Marionette, template) ->

  class CourseMapCreatorsItem extends Marionette.ItemView

    tagName: 'li'

    template: template

    triggers: {
      'mouseover a': 'active'
      'mouseout a': 'inactive'
      'click a':   'detail'
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
      data

    initialize: (options) ->
      @options = options || {}
      @creatorType = Marionette.getOption(@, 'creatorType')
      @listenTo(@model.collection, 'change:active', (activeCreator) ->
        if activeCreator == @model
          @$el.addClass('selected')
          @$el.removeClass('active')
        else
          @$el.removeClass('selected')
      )
      @$el.attr('data-creator', @model.id)