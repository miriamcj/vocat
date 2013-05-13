class Vocat.Views.CourseMap extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/course_map"]

	overlayOpen: false

	events:
		'click .js-navigate-exhibit': 'navigateExhibitDetail'
		'click .js-navigate-creator': 'navigateCreatorDetail'
		'click .js-navigate-project': 'navigateProjectDetail'
		'click .close':								'navigateGrid'

	initialize: (options)  ->
		window.Vocat.router.on "route:showCreatorProjectDetail", (course, creator, project) => @showCreatorProject(creator, project)
		window.Vocat.router.on "route:showCreatorDetail", (course, creator) => @showCreator(creator)
		window.Vocat.router.on "route:showProjectDetail", (course, project) => @showProject(project)
		window.Vocat.router.on "route:showGrid", (project) => @hideOverlay()
		@projects = window.Vocat.Instantiated.Collections.Project

		# A hack
		@courseId = @projects.first().get('course_id')
		console.log @courseId

		@creators = window.Vocat.Instantiated.Collections.Creator
		@render()

	navigateGrid: (event) ->
		data = @preventAndExtractData(event)
		path = 'courses/' + @courseId + '/evaluations'
		window.Vocat.router.navigate(path, true)

	navigateExhibitDetail: (event) ->
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
		$('.js-matrix--overlay').show()
		$('[data-behavior="matrix-creators"]').addClass('active')

	hideOverlay: () ->
		console.log 'called';
		$('.js-matrix--content').show()
		$('.js-matrix--overlay').hide()
		$('[data-behavior="matrix-creators"]').removeClass('active')

	showCreatorProject: (creator, project) ->
		@showOverlay()
		@detailView = new Vocat.Views.CourseMapCreatorProjectDetail({
			el: @$overlay
			projects: @projects,
			creators: @creators,
			model: {} # TODO: Add model
		})

	showCreator: (creator) ->
		@showOverlay()
		creator = @creators.get(creator)
		@detailView = new Vocat.Views.CourseMapCreatorDetail({
			el: @$overlay
			creator: creator
			projects: @projects,
			creators: @creators,
			model: {} # TODO: Add model
		})

	showProject: (project) ->
		@showOverlay()
		@detailView = new Vocat.Views.CourseMapProjectDetail({
			el: @$overlay
			projects: @projects,
			creators: @creators,
			model: {} # TODO: Add model
		})

	postRender: () ->
    $firstSlider = @$el.find('[data-behavior="matrix-slider"]').first()
    $leftButton = $('[data-behavior="matrix-slider-left"]')
    $rightButton = $('[data-behavior="matrix-slider-right"]')
    sliderWidth = $firstSlider.outerWidth(true)
    itemCount = $firstSlider.find('li').length
    itemWidth = $firstSlider.find('li').first().outerWidth()
    listWidth = itemCount * itemWidth;
    $('[data-behavior="matrix-slider"] ul').each( ->
      $(@).width(listWidth)
    )
    left = 0
    $leftButton.click((event) ->
      if left != 0
        left += 205
        $('[data-behavior="matrix-slider""] ul').css('left', left)
        $rightButton.removeClass('inactive')
        if left == 0
          $(@).addClass('inactive')
      event.preventDefault()
    )
    $rightButton.click((event) ->
      if listWidth + left > sliderWidth
        left -= 205
        $('[data-behavior="matrix-slider"] ul').css('left', left)
        $leftButton.removeClass('inactive')
        if listWidth + left <= sliderWidth
          $(@).addClass('inactive')
      event.preventDefault()
    )

	render: () ->
		#context = @prepareViewContext()

		context = {
			creators: @creators.toJSON()
			projects: @projects.toJSON()
		}

		@$el.html(@template(context))

		# Make the header STICKY
		$('[data-behavior=sticky-header]').waypoint((direction) ->
			if direction == "down"
				$(@).addClass('stuck')
			if direction == "up"
				$(@).removeClass('stuck')
		)


