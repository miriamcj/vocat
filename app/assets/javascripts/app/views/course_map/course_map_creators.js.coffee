define ['marionette', 'hbs!templates/course_map/course_map_creators', 'views/course_map/course_map_creators_item'], (Marionette, template, Item) ->

  class CourseMapCreatorsView extends Marionette.CompositeView

    itemView: Item

    template: template

    itemViewContainer: '[data-role="container"]'

    initialize: (options) ->
      @courseId = options.courseId
      @collection = options.collection

