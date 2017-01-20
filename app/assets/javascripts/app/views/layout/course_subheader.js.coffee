define (require) ->
  Marionette = require('marionette')

  class CourseSubheaderView extends Marionette.ItemView

    events: {
      'click @ui.trigger': 'clickTrigger'
    }

    ui: {
      trigger: '[data-behavior="view-toggle"]'
    }

    clickTrigger: (event) ->
      if window.VocatSubnavOverride
        event.preventDefault()
        el = event.currentTarget
        val = el.innerHTML
        if val == 'INDIVIDUAL WORK' || val == 'PEER WORK'
          Vocat.router.navigate("courses/#{window.VocatCourseId}/users/evaluations", true)
        else if val == 'GROUP WORK'
          Vocat.router.navigate("courses/#{window.VocatCourseId}/groups/evaluations", true)
        $(el).addClass('active') unless $(el).hasClass('active')
        $(el).siblings().removeClass('active')
      


    initialize: (options) ->
      @vent = options.vent
      @$trigger = @$el.find(@ui.trigger)
