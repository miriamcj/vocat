class Vocat.Views.CourseMap extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/course_map"]

	overlayOpen: false

	initialize: (options)  ->
		window.Vocat.router.on "route:showCreatorProjectDetail", (course, creator, project) => @showCreatorProject(creator, project)
		window.Vocat.router.on "route:showCreatorDetail", (course, creator) => @showCreator(creator)
		window.Vocat.router.on "route:showProjectDetail", (course, project) => @showProject(project)
		window.Vocat.router.on "route:showGrid", (project) => @showGrid()
		@projects = window.Vocat.Instantiated.Collections.Project
		@creators = window.Vocat.Instantiated.Collections.Creator
		@render()

	ensureOverlay: () ->
		if @overlayOpen == true then @hideOverlay()
		@$overlay.fadeIn()
		@overlayOpen = true
		$firstCell = $(@$el.find('#js-grid thead td:first').first())
		@$overlay.css({position: 'absolute', backgroundColor: 'white'})
		@$overlay.css({top: $firstCell.outerHeight() + 'px', left: $firstCell.outerWidth() + 'px'})
		@$overlay.height(@$el.height() - $firstCell.outerHeight())
		@$overlay.width(@$el.width() - $firstCell.outerWidth())

	hideOverlay: () ->
		#@$overlay.hide()
		#@overlayOpen = false

	showGrid: () ->
		@hideOverlay()

	showCreatorProject: (creator, project) ->
		@ensureOverlay()
		@detailView = new Vocat.Views.CourseMapCreatorProjectDetail({
			el: @$overlay
			projects: @projects,
			creators: @creators,
			model: {} # TODO: Add model
		})

	showCreator: (creator) ->
		@ensureOverlay()
		creator = @creators.get(creator)
		@detailView = new Vocat.Views.CourseMapCreatorDetail({
			el: @$overlay
			creator: creator
			projects: @projects,
			creators: @creators,
			model: {} # TODO: Add model
		})

	showProject: (project) ->
		@ensureOverlay()
		@detailView = new Vocat.Views.CourseMapProjectDetail({
			el: @$overlay
			projects: @projects,
			creators: @creators,
			model: {} # TODO: Add model
		})


	render: () ->
		@$el.html(@template({}))
		grid = new Vocat.Views.CourseMapGrid({
       el: @$el.find('#js-grid')
		})
		@$overlay = $('#js-map-overlay')






