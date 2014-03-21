define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/rubric/rubric_detail')

  class RubricDetailView extends Marionette.ItemView

    ui: {
      container: '[data-behavior="slide-down"]'
    }
    transition: true

    template: template

    initialize: (options) ->
      @model.fetch()
      @vent = Marionette.getOption(@, 'vent')
      @transition = Marionette.getOption(@, 'transition')

    transitionOut: () ->
      deferred = $.Deferred()
      if @transition == true
        @ui.container.slideUp({
          duration: 500,
          done: () ->
            deferred.resolve()
        })
      else
        @ui.container.hide()
      deferred

    onShow: () ->
      if @transition == true
        @ui.container.slideDown()
      else
        @ui.container.show()

    onRender: () ->
      @ui.container.hide()

