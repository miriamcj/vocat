define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/course_map/projects_empty')

  class CourseMapProjectsEmptyView extends Marionette.ItemView

    tagName: 'th'
    template: template
    attributes: {
      'data-behavior': 'navigate-project'
      'data-match-height-source': ''
    }

    initialize: (options) ->
      @courseId = options.courseId

    serializeData: () ->
      {
        courseId: @courseId
      }

