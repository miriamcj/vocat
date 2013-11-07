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
      if @collections.project.length > 1
        @ui.dropdowns.dropdownNavigation()

    onClose: () ->
      @vent.triggerMethod('close:overlay')
      $(window).off('keyup', @onKeyUp)

    onKeyUp: (e) ->
      code = if e.keyCode? then e.keyCode else e.which
      if code == 27 then @onClose()

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @collections = Marionette.getOption(@, 'collections')
      @listenTo(@collections.user,'change:active', () => @render())
      @listenTo(@collections.group,'change:active', () => @render())
      @listenTo(@collections.project,'change:active', () => @render())
      $(window).on('keyup', (e) => @onKeyUp(e))

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
      if @collections.project.getActive()?
        context.project = @collections.project.getActive().toJSON()
        _.each context.projects, (project, index) ->
          if project.id == context.project.id then context.projects[index].active = true
      if @collections.project.length > 1
        context.show_project_nav = true
      else
        context.show_project_nav = false
      context
