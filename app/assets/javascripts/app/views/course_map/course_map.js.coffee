define [
  'marionette',
  'hbs!templates/course_map/course_map',
  'views/course_map/course_map_projects',
  'views/course_map/course_map_creators',
  'views/course_map/course_map_matrix',
], (Marionette, template, CourseMapProjects, CourseMapCreators, CourseMapMatrix) ->

  class CourseMapView extends Marionette.Layout

    children: {}

    template: template

    # We need to store various states of the slider, including column widths.
    sliderData = {}

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

    initialize: (options) ->
      @collections = options.collections
      @courseId = options.courseId

      @children.creators = new CourseMapCreators({collection: @collections.creator, courseId: @courseId})
      @children.projects = new CourseMapProjects({collection: @collections.project, courseId: @courseId})
      @children.matrix = new CourseMapMatrix({collections: @collections})

      @setupListeners()


    positionOverlay: () ->
      # Position overlay
      #@overlay.css('margin-top', (@$el.find('.matrix--content').height() * -1)).css('z-index',200)

      # Set min height on overlay
      #@overlay.css('min-height', @$el.find('[data-behavior="matrix-creators-list"]').outerHeight())

    setupRowHover: () ->
      @$el.find('[data-creator]').hover(
        (event) =>
          creator = $(event.currentTarget).attr('data-creator')
          @$el.find('[data-creator="'+creator+'"]').addClass('active')
        ,
        (event) =>
          creator = $(event.currentTarget).attr('data-creator')
          @$el.find('[data-creator="'+creator+'"]').removeClass('active')
      )

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
      colWidth = slider.find('li').first().outerWidth()
      sliderWidth = colCount * colWidth
      minLeft = (sliderWidth * -1) + (colWidth * 4)
      slideElements = @$el.find('[data-behavior="matrix-slider"] ul')
      slideElements.each ->
        $(@).width(sliderWidth)
      @sliderData = {
        position: 0
        sliderWidth: sliderWidth
        minLeft: minLeft
        maxLeft: 0
        distance: colWidth
        slideElements: slideElements
      }

    triggers: {
      'click [data-behavior="matrix-slider-left"]':   'slider:left'
      'click [data-behavior="matrix-slider-right"]':  'slider:right'
    }

    setupListeners: () ->
      @listenTo(@, 'slider:right', () -> @slide('forward'))
      @listenTo(@, 'slider:left', () -> @slide('backward'))

      @listenTo(@, 'show', () -> @setContentContainerHeight() )
      @listenTo(@, 'show', () -> @calculateAndSetSliderWidth() )
      @listenTo(@, 'show', () -> @setupRowHover() )

    updateSliderControls: () ->
      left = @$el.find('[data-behavior="matrix-slider-left"]')
      right = @$el.find('[data-behavior="matrix-slider-right"]')
      # The width of the slider has to be greater than 4 columns for the slider to be able to slide.
      if (@sliderData.distance * 4) < @sliderData.sliderWidth
        if @sliderData.position == @sliderData.maxLeft then left.addClass('inactive') else left.removeClass('inactive')
        if @sliderData.position == @sliderData.minLeft then right.addClass('inactive') else right.removeClass('inactive')
      else
        left.addClass('inactive')
        right.addClass('inactive')

    slide: (direction) ->
      if direction == 'forward' then travel = @sliderData.distance * -1 else travel = @sliderData.distance * 1
      newLeft = @sliderData.position + travel
      if newLeft <= @sliderData.maxLeft && newLeft >= @sliderData.minLeft
        @sliderData.slideElements.css('left', newLeft)
        @sliderData.position = newLeft
      @updateSliderControls()



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
#    # Click events on a tags in this vieew that have data-behavior="routable" will be handled by this function, which will
#    # pass the href attribtue to the backbone router
#    handleRoutable: (e) ->
#      event.preventDefault()
#      href = $(e.currentTarget).attr('href')
#      if href
#        window.Vocat.router.navigate(href, true)
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
