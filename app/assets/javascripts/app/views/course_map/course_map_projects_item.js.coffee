define ['marionette', 'hbs!templates/course_map/course_map_projects_item'], (Marionette, template) ->
  class CourseMapProjectsItem extends Marionette.ItemView

    template: template

    initialize: (options) ->
