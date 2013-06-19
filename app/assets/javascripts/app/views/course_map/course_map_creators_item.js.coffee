define ['marionette', 'hbs!templates/course_map/course_map_creators_item'], (Marionette, template) ->
  class CourseMapCreatorsItem extends Marionette.ItemView

    template: template

    initialize: (options) ->
