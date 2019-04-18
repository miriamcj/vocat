define ['backbone', 'models/course'], (Backbone, courseModel) ->
  class CourseCollection extends Backbone.Collection

    model: courseModel
    activeModel: null

    url: '/api/v1/courses'

    getSearchTerm: () ->
      return 'section'
