class Vocat.Views.CourseMap extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/course_map"]

	overlayOpen: false

	initialize: (options)  ->
		window.Vocat.router.on "route:showCreatorProjectDetail", (creator, project) => @showCreatorProject(creator, project)
		window.Vocat.router.on "route:showCreatorDetail", (creator) => @showCreator(creator)
		window.Vocat.router.on "route:showProjectDetail", (project) => @showProject(project)
		window.Vocat.router.on "route:showGrid", (project) => @showGrid()
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
		@$overlay.fadeOut()
		@overlayOpen = false

	showGrid: () ->
		@hideOverlay()

	showCreatorProject: (creator, project) ->
		@ensureOverlay()
		@detailView = new Vocat.Views.CourseMapCreatorProjectDetail({
			el: @$overlay
			model: {} # TODO: Add model
		})

	showCreator: (creator) ->
		@ensureOverlay()

	showProject: (project) ->
		@ensureOverlay()

	render: () ->
		@$el.html(@template({}))
		grid = new Vocat.Views.CourseMapGrid({
       el: @$el.find('#js-grid')
		})
		@$overlay = $('#js-map-overlay')






