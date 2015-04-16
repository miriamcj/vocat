define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/submission/utility/utility')

  class UtilityView extends Marionette.ItemView

    template: template

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')

    serializeData: () ->
      data = super()
      data.courseId = @courseId
      data