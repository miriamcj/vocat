define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/course_map/projects_empty')

  class CourseMapProjectsEmptyView extends Marionette.ItemView

    tagName: 'li'
    template: template
    attributes: {
    }

    initialize: (options) ->
      @courseId = options.courseId

    serializeData: () ->
      {
        courseId: @courseId
      }

