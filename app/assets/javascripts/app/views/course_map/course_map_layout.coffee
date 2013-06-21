define [
  'marionette',
  'hbs!templates/course_map/course_map_layout',
  'views/course_map/projects',
  'views/course_map/creators',
  'views/course_map/matrix',
  'views/course_map/detail_creator',
  'views/course_map/detail_project',
  'views/submission/submission_layout',
  'views/course_map/header'
], (Marionette, template, CourseMapProjects, CourseMapCreators, CourseMapMatrix, CourseMapDetailCreator, CourseMapDetailProject, CourseMapDetailCreatorProject, CourseMapHeader) ->

  class CourseMapView extends Marionette.Layout

    children: {}

    template: template

    # We need to store various states of the slider, including column widths.
    sliderColWidth: 200
    sliderWidth: 3000
    sliderMinLeft: 0
    sliderPosition: 0

    ui: {
      header: '[data-region="overlay-header"]'
      overlay: '[data-region="overlay"]'
      sliderLeft: '[data-behavior="matrix-slider-left"]'
      sliderRight: '[data-behavior="matrix-slider-right"]'
    }

    triggers: {
      'click [data-behavior="matrix-slider-left"]':   'slider:left'
      'click [data-behavior="matrix-slider-right"]':  'slider:right'
    }

    regions: {
      creators: '[data-region="creators"]'
      projects: '[data-region="projects"]'
      matrix: '[data-region="matrix"]'
      header: '[data-region="overlay-header"]'
      overlay: '[data-region="overlay"]'
    }

    onRender: () ->
      @creators.show(@children.creators)
      @projects.show(@children.projects)
      @matrix.show(@children.matrix)

      # TODO: Consider whether this is the right spot for this.
      @header.show(@children.header)

      @bindUIElements()

    initialize: (options) ->
      @collections = options.collections
      @courseId = options.courseId

#      @listenTo(@, 'all', (event) ->
#        console.log event, 'event heard'
#      )

      # Whenever we show the overlay region, we need to make it appear
      @listenTo(@overlay, 'show', () ->
        @onOpenOverlay()
      )

      @listenTo(@header, 'show', () ->
          @onOpenHeader()
      )

      @children.creators = new CourseMapCreators({collection: @collections.creator, courseId: @courseId, vent: @})
      @children.projects = new CourseMapProjects({collection: @collections.project, courseId: @courseId, vent: @})
      @children.matrix = new CourseMapMatrix({collections: @collections, courseId: @courseId, vent: @})
      @children.header = new CourseMapHeader({collections: @collections, courseId: @courseId, vent: @})

    onOpenDetailCreator: (args) ->
      @collections.creator.setActive(args.creator)
      @collections.project.setActive(null)
      Vocat.courseMapRouter.navigate("courses/#{@courseId}/evaluations/creator/#{args.creator}")
      view = new CourseMapDetailCreator({collections: @collections, courseId: @courseId, vent: @, creatorId: args.creator})
      @overlay.show(view)

    onOpenDetailProject: (args) ->
      @collections.project.setActive(args.project)
      @collections.creator.setActive(null)
      Vocat.courseMapRouter.navigate("courses/#{@courseId}/evaluations/project/#{args.project}")
      view = new CourseMapDetailProject({collections: @collections, courseId: @courseId, vent: @, projectId: args.project})
      @overlay.show(view)

    onOpenDetailCreatorProject: (args) ->
      @collections.creator.setActive(args.creator)
      @collections.project.setActive(args.project)
      Vocat.courseMapRouter.navigate("courses/#{@courseId}/evaluations/creator/#{args.creator}/project/#{args.project}")
      view = new CourseMapDetailCreatorProject({collections: @collections, courseId: @courseId, vent: @, creator: @collections.creator.getActive(), project: @collections.project.getActive()})
      @overlay.show(view)

    onRowInactive: (args) ->
      @$el.find('[data-creator="'+args.creator+'"]').removeClass('active')

    onRowActive: (args) ->
      @$el.find('[data-creator="'+args.creator+'"]').addClass('active')

    onColActive: (args) ->
      # For now, do nothing.
      #@$el.find('[data-project="'+args.project+'"]').addClass('active')

    onColInactive: (args) ->
      # For now, do nothing.
      #@$el.find('[data-project="'+args.project+'"]').removeClass('active')

    onRepaint: () ->
      @setContentContainerHeight()
      @calculateAndSetSliderWidth()

    onShow: () ->
      @onRepaint()

    onSliderLeft: () ->
      console.log 'onSliderLeft executed'
      @slide('backwards')

    onSliderRight: () ->
      console.log 'onSliderRight executed'
      @slide('forward')

    onOpenOverlay: () ->

      @ui.overlay.css('margin-top', (@$el.find('.matrix--content').height() * -1)).css('z-index',200)

      # Set min height on overlay
      @ui.overlay.css('min-height', @$el.find('[data-behavior="matrix-creators-list"]').outerHeight())

      # Fade it in if not visible
      if !@ui.overlay.is(':visible')
        @ui.overlay.fadeIn(500)

      if !@ui.header.is(':visible')
        @ui.header.fadeIn(500)


    onOpenHeader: () ->
      # Fade it in if not visible

    onCloseOverlay: (args) ->

      Vocat.courseMapRouter.navigate("courses/#{@courseId}/evaluations")

      if @ui.overlay.is(':visible')
        @ui.overlay.fadeOut 500, () =>

      if @ui.header.is(':visible')
        @ui.header.fadeOut 500, () =>


#    setupRowHover: () ->
#      @$el.find('[data-creator]').hover(
#        (event) =>
#          creator = $(event.currentTarget).attr('data-creator')
#          @$el.find('[data-creator="'+creator+'"]').addClass('active')
#        ,
#        (event) =>
#          creator = $(event.currentTarget).attr('data-creator')
#          @$el.find('[data-creator="'+creator+'"]').removeClass('active')
#      )

    setContentContainerHeight: () ->
      # Content container should be as tall as the window
      $spacers = @$el.find('.matrix--row-spacer')
      spacerOffset = @$el.find('.matrix--row-spacer').offset()
      bodyHeight = $('body').outerHeight()
      diff = bodyHeight - spacerOffset.top
      $spacers.css('min-height', diff + 'px');
      height = @$el.find('.matrix--content').outerHeight() +  @$el.find('.matrix--overlay header').outerHeight()

    calculateAndSetSliderWidth: () ->
      slider = @$el.find('[data-behavior="matrix-slider"]').first()
      colCount = slider.find('li').length
      @sliderWidth = colCount * @sliderColWidth
      @sliderMinLeft = (@sliderWidth * -1) + (@sliderColWidth * 4)
      @$el.find('[data-behavior="matrix-slider"] ul').width(@sliderWidth)

    updateSliderControls: () ->
      # The width of the slider has to be greater than 4 columns for the slider to be able to slide.
      if (@sliderColWidth * 4) < @sliderWidth
        if @sliderPosition == 0 then @ui.sliderLeft.addClass('inactive') else @ui.sliderLeft.removeClass('inactive')
        if @sliderPosition == @sliderMinLeft then @ui.sliderRight.addClass('inactive') else @ui.sliderRight.removeClass('inactive')
      else
        @ui.sliderLeft.addClass('inactive')
        @ui.sliderRight.addClass('inactive')

    slide: (direction) ->
      if direction == 'forward' then travel = @sliderColWidth * -1 else travel = @sliderColWidth * 1
      newLeft = @sliderPosition + travel
      if newLeft <= 0 && newLeft >= @sliderMinLeft
        @$el.find('[data-behavior="matrix-slider"] ul').css('left', newLeft)
        @sliderPosition = newLeft
      @updateSliderControls()


#
#
#    # Click events on a tags in this vieew that have data-behavior="routable" will be handled by this function, which will
#    # pass the href attribtue to the backbone router
#    handleRoutable: (e) ->
#      event.preventDefault()
#      href = $(e.currentTarget).attr('href')
#      if href
#        window.Vocat.courseMapRouter.navigate(href, true)


#    headerPartial:  HBT["app/templates/course_map/partials/overlay_header"]
#
#    overlayOpen: false
#
#    events:
#      'click [data-behavior="navigate-creator"]':     'navigateCreatorDetail'
#      'click [data-behavior="navigate-project"]':     'navigateProjectDetail'
#      'click [data-behavior="matrix-overlay-close"]': 'navigateGrid'
#      'click [data-behavior="routable"]':             'handleRoutable'
#
#    initialize: (options)  ->
#      window.Vocat.router.on "route:showCreatorProjectDetail", (course, creator, project) => @showCreatorProjectDetail(creator, project)
#      window.Vocat.router.on "route:showCreatorDetail", (course, creator) => @showCreatorDetail(creator)
#      window.Vocat.router.on "route:showProjectDetail", (course, project) => @showProjectDetail(project)
#      window.Vocat.router.on "route:showGrid", (project) => @hideOverlay()
#      window.Vocat.Dispatcher.on "courseMap:redraw", () => @redraw()
#      window.Vocat.Dispatcher.on "courseMap:childViewLoaded", (view) => @updateOverlay(view)
#      window.Vocat.Dispatcher.bind 'courseMap:creatorSelected', (creatorId) => @setActiveCreator(creatorId)
#      window.Vocat.Dispatcher.bind 'courseMap:creatorDeselected', () => @unsetActiveCreator()
#
#
#      # This view pulls projects and creators from bootstrapped data on the page
#      @projects = window.Vocat.Instantiated.Collections.Project
#      @creators = window.Vocat.Instantiated.Collections.Creator
#
#      # A hack to get the course ID
#      @courseId = @projects.first().get('course_id')
#
#      # Like other parent views, this one renders itself.
#      @render()
#
#      # De-activate the main sticky header on this page, so our coursemap header can be sticky.
#      $('[data-behavior="sticky-header"]').stickyHeader('destroy')
#      @$el.find('[data-behavior="sticky-header"]').stickyHeader()
#
#
#
#    setActiveCreator: (creatorId) ->
#      @unsetActiveCreator()
#      @$el.find('[data-creator="' + creatorId + '"]').addClass('active')
#
#    unsetActiveCreator: () ->
#      @$el.find('[data-behavior="matrix-creators-list"] li.active').removeClass('active')
#
#
#    navigateGrid: (event) ->
#      data = @preventAndExtractData(event)
#      path = 'courses/' + @courseId + '/evaluations'
#      window.Vocat.router.navigate(path, true)
#
#    navigateCreatorProjectDetail: (event) ->
#      data = @preventAndExtractData(event)
#      path = 'courses/' + @courseId + '/evaluations/creator/' + data.creator + '/project/' + data.project
#      window.Vocat.router.navigate(path, true)
#
#    navigateCreatorDetail: (event) ->
#      data = @preventAndExtractData(event)
#      path = 'courses/' + @courseId + '/evaluations/creator/' + data.creator
#      window.Vocat.router.navigate(path, true)
#
#    navigateProjectDetail: (event) ->
#      data = @preventAndExtractData(event)
#      path = 'courses/' + @courseId + '/evaluations/project/' + data.project
#      window.Vocat.router.navigate(path, true)
#
#    preventAndExtractData: (event) ->
#      event.preventDefault()
#      $(event.currentTarget).data()
#
#    hideOverlay: () ->
#      window.Vocat.Dispatcher.trigger('courseMap:creatorDeselected')
#      @overlay.fadeOut()
#      @$el.find('[data-behavior="overlay-header"]').fadeOut()
#      @$el.find('.matrix').removeClass('matrix--overlay-open')
#
#    updateOverlay: (view) ->
#      newView = view
#      contentContainer = @overlay.find('[data-behavior="overlay-content"]').first()
#      $(contentContainer).html(newView.el)
#
#      if @currentView? then @currentView.remove()
#
#      if !@overlay.is(':visible')
#        @overlay.fadeIn(500)
#
#      @currentView = newView
#
#      @$el.find('.matrix').addClass('matrix--overlay-open')
#      $('[data-behavior="matrix-creators"]').addClass('active')
#
#    showCreatorProjectDetail: (creator, project) ->
#      window.Vocat.Dispatcher.trigger('courseMap:creatorSelected', creator)
#      @detailView = new Vocat.Views.CourseMapCreatorProjectDetail({
#        courseId: @courseId
#        project: @projects.get(project)
#        creator: @creators.get(creator)
#      })
#      @updateHeader({creator: @creators.get(creator), project: @projects.get(project)})
#
#    showCreatorDetail: (creator) ->
#      window.Vocat.Dispatcher.trigger('courseMap:creatorSelected', creator)
#      @detailView = new Vocat.Views.CourseMapCreatorDetail({
#        courseId: @courseId
#        creator: @creators.get(creator)
#        projects: @projects
#        creators: @creators
#      })
#      @updateHeader({creator: @creators.get(creator)})
#      @detailView.render()
#
#    showProjectDetail: (project) ->
#      @detailView = new Vocat.Views.CourseMapProjectDetail({
#        courseId: @courseId
#        project: @projects.get(project)
#        projects: @projects
#        creators: @creators
#      })
#      @updateHeader({project: @projects.get(project)})
#      @detailView.render()
#
#    updateHeader: (options) ->
#      context = {
#        projects: @projects.toJSON()
#        creators: @creators.toJSON()
#        courseId: @courseId
#      }
#      if options.creator? then context.creator = options.creator.toJSON()
#      if options.project? then context.project = options.project.toJSON()
#      partial = @headerPartial(context)
#      target = @$el.find('[data-behavior="overlay-header"]')
#      target.html(partial).show()
#      target.find('[data-behavior="dropdown"]').dropdownNavigation()
#
#    initializeOverlay: () ->
#      @overlay = @$el.find('.js-matrix--overlay').first()
#


#    redraw: () ->
#      @setContentContainerHeight()
#      @calculateAndSetSliderWidth()
#      @updateSliderControls()
#      @setupRowHover()
#
#    render: () ->
#      context = {
#        courseId: @courseId
#        creators: @creators.toJSON()
#        projects: @projects.toJSON()
#      }
#
#      @$el.html(@template(context))
#
#      @initializeOverlay()
#      @redraw()
#
#      matrixCells = new Vocat.Views.CourseMapMatrixCells({
#        el: @$el.find('.js-matrix--content').first()
#        creators: @creators
#        projects: @projects
#        courseId: @courseId
#      })
