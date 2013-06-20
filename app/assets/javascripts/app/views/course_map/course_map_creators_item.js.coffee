define ['marionette', 'hbs!templates/course_map/course_map_creators_item'], (Marionette, template) ->

  class CourseMapCreatorsItem extends Marionette.ItemView

    tagName: 'li'

    template: template

    triggers: {
      'click a':   'course_map:detail:creator'
    }

    attributes: {
      'data-behavior': 'navigate-creator'
    }

    serializeData: () ->
      data = super()
      data.courseId = @options.courseId
      data

    showCreatorDetail: (args) ->
      console.log 'fired global trigger'
      window.Vocat.vent.trigger('course_map:detail:creator')

    initialize: (options) ->
      @listenTo(@, 'course_map:detail:creator', () -> console.log 'heard local trigger')

      @listenTo(window.Vocat.vent, 'course_map:detail:creator', () -> console.log 'heard global trigger')
      @$el.attr('data-creator', @model.id)