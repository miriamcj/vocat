define ['marionette', 'hbs!templates/course_map/course_map_projects_item'], (Marionette, template) ->
  class CourseMapProjectsItem extends Marionette.ItemView

    tagName: 'li'
    template: template
    attributes: {
      'data-behavior': 'navigate-project'
    }

    serializeData: () ->
      data = super()
      data.courseId = @options.courseId
      data

    initialize: (options) ->
      @$el.attr('data-project', @model.id)