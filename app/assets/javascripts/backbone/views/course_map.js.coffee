class Vocat.Views.CourseMap extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/course_map"]

	overlayOpen: false

	events:
		'click .js-navigate-exhibit': 									'navigateCreatorProjectDetail'
		'click .js-navigate-creator': 									'navigateCreatorDetail'
		'click .js-navigate-project': 									'navigateProjectDetail'
		'click .close':																	'navigateGrid'
		'click [data-behavior="matrix-slider-left"]':		'slideLeft'
		'click [data-behavior="matrix-slider-right"]':	'slideRight'

	initialize: (options)  ->

		window.Vocat.router.on "route:showCreatorProjectDetail", (course, creator, project) => @showCreatorProjectDetail(creator, project)
		window.Vocat.router.on "route:showCreatorDetail", (course, creator) => @showCreatorDetail(creator)
		window.Vocat.router.on "route:showProjectDetail", (course, project) => @showProjectDetail(project)
		window.Vocat.router.on "route:showGrid", (project) => @hideOverlay()

		@sliderData = {}

		@projects = window.Vocat.Instantiated.Collections.Project
		@creators = window.Vocat.Instantiated.Collections.Creator

		# A hack
		@courseId = @projects.first().get('course_id')

		@render()

		@submissions = new Vocat.Collections.Submission({courseId: @courseId})
		$.when(@submissions.fetch()).then () =>
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
			projects: @projects,
			creators: @creators,
		})
		@updateOverlay(@detailView)

	showCreatorDetail: (creator) ->
		@detailView = new Vocat.Views.CourseMapCreatorDetail({
			creator: creator
			projects: @projects,
			creators: @creators,
		})
		@updateOverlay(@detailView)

	showProjectDetail: (project) ->
		@detailView = new Vocat.Views.CourseMapProjectDetail({
			projects: @projects,
			creators: @creators,
		})
		@updateOverlay(@detailView)

	initializeOverlay: () ->
		@overlay = @$el.find('.js-matrix--overlay').first()
		@overlay.position({
			my: 'left top'
			at: 'left top'
			of: $('.js-matrix--content').first()
		})
		@overlay.hide();


	initializeSlider: () ->
		firstSlider = @$el.find('[data-behavior="matrix-slider"]').first()
		itemCount = firstSlider .find('li').length
		itemWidth = firstSlider .find('li').first().outerWidth()
		listWidth = itemCount * itemWidth;
		minLeft = (listWidth * -1) + (itemWidth * 4)
		slideElements = @$el.find('[data-behavior="matrix-slider"] ul')
		slideElements.each ->
				$(@).width(listWidth)

		@sliderData = {
			position: 0
			listWidth: listWidth
			minLeft: minLeft
			maxLeft: 0
			distance: 205
			slideElements: slideElements
		}

		@updateSliderControls()

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

	initializeStickyHeader: () ->
		$('[data-behavior=sticky-header]').waypoint((direction) ->
			if direction == "down"
				$(@).addClass('stuck')
			if direction == "up"
				$(@).removeClass('stuck')
		)

	createRows: () ->
		# DO THIS....

	render: () ->
		#context = @prepareViewContext()

		context = {
			creators: @creators.toJSON()
			projects: @projects.toJSON()
			rows: @createRows()
		}

		@$el.html(@template(context))

		@initializeSlider()
		@initializeOverlay()
		@initializeStickyHeader()



