define [
  'marionette',
  'hbs!templates/course_map/header'
], (
  Marionette,
  template,
) ->
  class CourseMapHeader extends Marionette.ItemView

    template: template

    ui: {
      dropdowns: '[data-behavior="dropdown"]'
    }

    events:
      'click [data-behavior="routable"]':  'onExecuteRoute'

    onExecuteRoute: (e) ->
      e.preventDefault()
      href = $(e.currentTarget).attr('href')
      if href
        window.Vocat.courseMapRouter.navigate(href, true)

    triggers: {
      'click [data-behavior="overlay-close"]' : 'close'
    }

    onRender: () ->
      @ui.dropdowns.dropdownNavigation()

    onClose: () ->
      @vent.triggerMethod('close:overlay')

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @collections = Marionette.getOption(@, 'collections')

      @listenTo(@collections.creator,'change:active', () => @render())
      @listenTo(@collections.project,'change:active', () => @render())

    serializeData: () ->
      context = {}
      context.projects = @collections.project.toJSON()
      if @collections.creator.getActive()? then context.creator = @collections.creator.getActive().toJSON()
      if @collections.project.getActive()? then context.project = @collections.project.getActive().toJSON()
      context
