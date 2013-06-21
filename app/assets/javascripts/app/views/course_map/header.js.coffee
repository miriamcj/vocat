define [
  'marionette',
  'hbs!templates/course_map/header'
], (
  Marionette,
  template,
) ->
  class CourseMapHeader extends Marionette.ItemView

    template: template

    triggers: {
      'click [data-behavior="overlay-close"]' : 'close'
    }

    onClose: () ->
      console.log 'test'
      @vent.triggerMethod('close:overlay')

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @collections = Marionette.getOption(@, 'collections')

      @listenTo(@collections.creator,'change:active', () => @render())
      @listenTo(@collections.project,'change:active', () => @render())

    serializeData: () ->
      context = {}
      if @collections.creator.getActive()? then context.creator = @collections.creator.getActive().toJSON()
      if @collections.project.getActive()? then context.project = @collections.project.getActive().toJSON()
      context
