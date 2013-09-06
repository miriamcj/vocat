define [
  'marionette',
  'hbs!templates/course_map/header'
], (
  Marionette,
  template,
) ->
  class CourseMapHeader extends Marionette.ItemView

    template: template
    creatorType: 'User'

    ui: {
      dropdowns: '[data-behavior="dropdown"]'
    }

    events:
      'click [data-behavior="routable"]':  'onExecuteRoute'

    onExecuteRoute: (e) ->
      e.preventDefault()
      href = $(e.currentTarget).attr('href')
      if href
        window.Vocat.router.navigate(href, true)

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
      @listenTo(@collections.user,'change:active', () => @render())
      @listenTo(@collections.group,'change:active', () => @render())
      @listenTo(@collections.project,'change:active', () => @render())

    serializeData: () ->
      context = {}
      context.projects = @collections.project.toJSON()
      context.creator = null
      context.creatorType = @creatorType
      if @creatorType == 'User'
        context.creatorIsUser = true
        context.creatorIsGroup = false
        context.creators = @collections.user.toJSON()
      else if @creatorType == 'Group'
        context.creatorIsUser = false
        context.creatorIsGroup = true
        context.creators = @collections.group.toJSON()
      if @collections.group.getActive()? then context.creator = @collections.group.getActive().toJSON()
      if @collections.user.getActive()? then context.creator = @collections.user.getActive().toJSON()
      if context.creator != null then context.activeCreator = true else context.activeCreator = false
      if @collections.project.getActive()? then context.project = @collections.project.getActive().toJSON()
      context
