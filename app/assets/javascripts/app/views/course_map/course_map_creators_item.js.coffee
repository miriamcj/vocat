define ['marionette', 'hbs!templates/course_map/course_map_creators_item'], (Marionette, template) ->

  class CourseMapCreatorsItem extends Marionette.ItemView

    tagName: 'li'
    template: template
    attributes: {
      'data-behavior': 'navigate-creator'
    }

    initialize: (options) ->
      @$el.attr('data-creator', @model.id)