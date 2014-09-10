define ['marionette', 'hbs!templates/course_map/projects_item'], (Marionette, template) ->
  class CourseMapProjectsItem extends Marionette.ItemView

    tagName: 'th'
    template: template
    attributes: {
      'data-behavior': 'navigate-project'
      'data-match-height-source': ''
    }

    triggers: {
      'mouseover a': 'active'
      'mouseout a': 'inactive'
      'click a':   'detail'
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
      @creatorType = Marionette.getOption(@, 'creatorType')
      @$el.attr('data-project', @model.id)
      @vent = options.vent

    onShow: () ->
      @vent.trigger('project_item:shown', @$el.height())
