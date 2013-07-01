define ['marionette', 'hbs!templates/course_map/projects_item'], (Marionette, template) ->
  class CourseMapProjectsItem extends Marionette.ItemView

    tagName: 'li'
    template: template
    attributes: {
      'data-behavior': 'navigate-project'
    }

    triggers: {
      'mouseover a': 'active'
      'mouseout a': 'inactive'
      'click a':   'detail'
    }

    serializeData: () ->
      data = super()
      data.courseId = @options.courseId
      data

    initialize: (options) ->
      @$el.attr('data-project', @model.id)