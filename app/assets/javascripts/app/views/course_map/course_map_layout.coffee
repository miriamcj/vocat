define [
  'marionette',
  'hbs!templates/course_map/course_map_layout',
  'views/course_map/projects',
  'views/course_map/creators',
  'views/course_map/matrix',
  'views/course_map/detail_creator',
  'views/course_map/detail_project',
  'views/submission/submission_layout',
  'views/course_map/header',
  '../../../layout/plugins'
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
      courseMapHeader: '.matrix--column-header'
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

      @updateSliderControls()

      # TODO: Consider whether this is the right spot for this.
      @header.show(@children.header)

      @bindUIElements()

      setTimeout () =>
        @ui.courseMapHeader.stickyHeader()
      , 500

    initialize: (options) ->
      @collections = options.collections
      @courseId = options.courseId

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
      view = new CourseMapDetailCreator({collections: _.clone(@collections), courseId: @courseId, vent: @, creatorId: args.creator})
      @overlay.show(view)

    onOpenDetailProject: (args) ->
      @collections.project.setActive(args.project)
      @collections.creator.setActive(null)
      Vocat.courseMapRouter.navigate("courses/#{@courseId}/evaluations/project/#{args.project}")
      view = new CourseMapDetailProject({collections: _.clone(@collections), courseId: @courseId, vent: @, projectId: args.project})
      @overlay.show(view)

    onOpenDetailCreatorProject: (args) ->
      @collections.creator.setActive(args.creator)
      @collections.project.setActive(args.project)
      Vocat.courseMapRouter.navigate("courses/#{@courseId}/evaluations/creator/#{args.creator}/project/#{args.project}")
      view = new CourseMapDetailCreatorProject({collections: _.clone(@collections), courseId: @courseId, vent: @, creator: @collections.creator.getActive(), project: @collections.project.getActive()})
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
      @slide('backwards')

    onSliderRight: () ->
      @slide('forward')

    onOpenOverlay: () ->
      @ui.overlay.css({top: '8rem', zIndex: 250, position: 'absolute', minHeight: @matrix.$el.outerHeight()})


#      @ui.overlay.parent().height(@ui.overlay.outerHeight())
#      console.log 'setting margin top to: ' + (@$el.find('.matrix--content').height() * -1)
#      @ui.overlay.css('margin-top', (@$el.find('.matrix--content').height() * -1)).css('z-index',200)
#      # Set min height on overlay
#      @ui.overlay.css('min-height', @$el.find('[data-behavior="matrix-creators-list"]').outerHeight())
#      # Fade it in if not visible
      if !@ui.overlay.is(':visible')
        @ui.overlay.fadeIn(500)
      if !@ui.header.is(':visible')
        @ui.header.fadeIn(500)

    onOpenHeader: () ->
      # Fade it in if not visible

    onCloseOverlay: (args) ->
      @matrix.$el.css({visibility: 'visible'})
      @collections.project.setActive(null)
      @collections.creator.setActive(null)

      Vocat.courseMapRouter.navigate("courses/#{@courseId}/evaluations")
      if @ui.overlay.is(':visible')
        @ui.overlay.fadeOut 500, () =>
      if @ui.header.is(':visible')
        @ui.header.fadeOut 500, () =>

    setContentContainerHeight: () ->
      # Content container should be as tall as the window
#      $spacers = @$el.find('.matrix--row-spacer')
#      spacerOffset = @$el.find('.matrix--row-spacer').offset()
#      bodyHeight = $('body').outerHeight()
#      diff = bodyHeight - spacerOffset.top
#      $spacers.css('min-height', diff + 'px');
#      height = @$el.find('.matrix--content').outerHeight() +  @$el.find('.matrix--overlay header').outerHeight()

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

