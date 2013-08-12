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
  'views/abstract/sliding_grid_layout'
  '../../../layout/plugins'
], (Marionette, template, CourseMapProjects, CourseMapCreators, CourseMapMatrix, CourseMapDetailCreator, CourseMapDetailProject, CourseMapDetailCreatorProject, CourseMapHeader, SlidingGridLayout) ->

  class CourseMapView extends SlidingGridLayout

    children: {}

    template: template

    sliderVisibleColumns: 4

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

      @sliderPosition = 0
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

    onOpenOverlay: () ->
      @ui.overlay.css({top: '8rem', zIndex: 250, position: 'absolute', minHeight: @matrix.$el.outerHeight()})
      if !@ui.overlay.is(':visible')
        @ui.overlay.fadeIn(500)
      if !@ui.header.is(':visible')
        @ui.header.fadeIn(500)
      $('html, body').animate({ scrollTop: 116 + 34 }, 'fast')
      @$el.find('.matrix--controls a').css(visibility: 'hidden')

    onOpenHeader: () ->
      # Fade it in if not visible

    onCloseOverlay: (args) ->
      @matrix.$el.css({visibility: 'visible'})
      @collections.project.setActive(null)
      @collections.creator.setActive(null)

      $('html, body').animate({ scrollTop: 116 + 34 }, 'fast')
      @$el.find('.matrix--controls a').css(visibility: 'visible')

      Vocat.courseMapRouter.navigate("courses/#{@courseId}/evaluations")
      if @ui.overlay.is(':visible')
        @ui.overlay.fadeOut 500, () =>
      if @ui.header.is(':visible')
        @ui.header.fadeOut 500, () =>

