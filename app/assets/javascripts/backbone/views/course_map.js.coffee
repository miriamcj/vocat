class Vocat.Views.CourseMap extends Vocat.Views.AbstractView

  template: HBT["backbone/templates/course_map"]

  overlayOpen: false

  events:
    'click .js-navigate-exhibit':                   'navigateCreatorProjectDetail'
    'click .js-navigate-creator':                   'navigateCreatorDetail'
    'click .js-navigate-project':                   'navigateProjectDetail'
    'click [data-behavior="matrix-overlay-close"]': 'navigateGrid'
    'click [data-behavior="matrix-slider-left"]':   'slideLeft'
    'click [data-behavior="matrix-slider-right"]':  'slideRight'

  initialize: (options)  ->

    window.Vocat.router.on "route:showCreatorProjectDetail", (course, creator, project) => @showCreatorProjectDetail(creator, project)
    window.Vocat.router.on "route:showCreatorDetail", (course, creator) => @showCreatorDetail(creator)
    window.Vocat.router.on "route:showProjectDetail", (course, project) => @showProjectDetail(project)
    window.Vocat.router.on "route:showGrid", (project) => @hideOverlay()
    window.Vocat.Dispatcher.on "courseMap:redraw", () => @redraw()

    @sliderData = {}

    @projects = window.Vocat.Instantiated.Collections.Project
    @creators = window.Vocat.Instantiated.Collections.Creator

    # A hack
    @courseId = @projects.first().get('course_id')

    @render()

  navigateGrid: (event) ->
    data = @preventAndExtractData(event)
    path = 'courses/' + @courseId + '/evaluations'
    window.Vocat.router.navigate(path, true)

  navigateCreatorProjectDetail: (event) ->
    data = @preventAndExtractData(event)
    path = 'courses/' + @courseId + '/evaluations/creator/' + data.creator + '/project/' + data.project
    window.Vocat.router.navigate(path, true)

  navigateCreatorDetail: (event) ->
    data = @preventAndExtractData(event)
    path = 'courses/' + @courseId + '/evaluations/creator/' + data.creator
    window.Vocat.router.navigate(path, true)

  navigateProjectDetail: (event) ->
    data = @preventAndExtractData(event)
    path = 'courses/' + @courseId + '/evaluations/project/' + data.project
    window.Vocat.router.navigate(path, true)

  preventAndExtractData: (event) ->
    event.preventDefault()
    $(event.currentTarget).data()

  showOverlay: () ->
    $('.js-matrix--content').hide()
    @overlay.fadeIn()
    $('[data-behavior="matrix-creators"]').addClass('active')

  hideOverlay: () ->
    @overlay.fadeOut()
    $('[data-behavior="matrix-creators"]').removeClass('active')

  updateOverlay: (view) ->
    container = view.el
    if @overlay.is(":visible")
      @overlay.fadeOut(250, () =>
        @overlay.html(container)
        @overlay.fadeIn(250)
      )
    else
      @overlay.html(container)
      @overlay.fadeIn()

    $('[data-behavior="matrix-creators"]').addClass('active')

  showCreatorProjectDetail: (creator, project) ->
    @detailView = new Vocat.Views.CourseMapCreatorProjectDetail({
      courseId: @courseId,
      projects: @projects,
      creators: @creators,
    })
    @updateOverlay(@detailView)

  showCreatorDetail: (creator) ->
    @detailView = new Vocat.Views.CourseMapCreatorDetail({
      courseId: @courseId,
      creator: creator
      projects: @projects,
      creators: @creators,
    })
    @updateOverlay(@detailView)

  showProjectDetail: (project) ->
    @detailView = new Vocat.Views.CourseMapProjectDetail({
      courseId: @courseId,
      projects: @projects,
      creators: @creators,
    })
    @updateOverlay(@detailView)

  initializeOverlay: () ->
    @overlay = @$el.find('.js-matrix--overlay').first()
    @overlay.show()
    @overlay.position({
      my: 'left top'
      at: 'left top'
      of: $('.js-matrix--content').first()
    })
    @overlay.hide()

  updateSliderControls: () ->
    left = @$el.find('[data-behavior="matrix-slider-left"]')
    right = @$el.find('[data-behavior="matrix-slider-right"]')
    if @sliderData.position == @sliderData.maxLeft then left.addClass('inactive') else left.removeClass('inactive')
    if @sliderData.position == @sliderData.minLeft then right.addClass('inactive') else right.removeClass('inactive')

  slideLeft: (e) ->
    e.preventDefault()
    @slide('backward')

  slideRight: (e) ->
    e.preventDefault()
    @slide('forward')

  slide: (direction) ->
    if direction == 'forward' then travel = @sliderData.distance * -1 else travel = @sliderData.distance * 1
    newLeft = @sliderData.position + travel
    if newLeft <= @sliderData.maxLeft && newLeft >= @sliderData.minLeft
      @sliderData.slideElements.css('left', newLeft)
      @sliderData.position = newLeft
    @updateSliderControls()

  setContentContainerHeight: () ->
    height = @$el.find('[data-behavior="matrix-creators-list"]').first().height()
    @$el.find('.matrix--content').first().css('min-height', height)
    @$el.find('.js-matrix--overlay').first().css('min-height', height)

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
      distance: 205
      slideElements: slideElements
    }

  initializeStickyHeader: () ->
    $('[data-behavior=sticky-header]').waypoint((direction) ->
      if direction == "down"
        $(@).addClass('stuck')
      if direction == "up"
        $(@).removeClass('stuck')
    )

  redraw: () ->
    @setContentContainerHeight()
    @calculateAndSetSliderWidth()
    @updateSliderControls()
    @initializeStickyHeader()

  render: () ->
    context = {
      creators: @creators.toJSON()
      projects: @projects.toJSON()
    }

    @$el.html(@template(context))

    @initializeOverlay()
    @redraw()

    matrixCells = new Vocat.Views.CourseMapMatrixCells({
      el: @$el.find('.js-matrix--content').first()
      creators: @creators
      projects: @projects
      courseId: @courseId
    })
