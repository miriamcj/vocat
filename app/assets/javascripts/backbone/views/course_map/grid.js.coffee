class Vocat.Views.CourseMapGrid extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/course_map/grid"]

	events:
		'click .js-navigate-exhibit': 'navigateExhibitDetail'
		'click .js-navigate-creator': 'navigateCreatorDetail'
		'click .js-navigate-project': 'navigateProjectDetail'

	initialize: (options) ->
		@projects = window.Vocat.Instantiated.Collections.Project
		@creators = window.Vocat.Instantiated.Collections.Creator
		@submissions = window.Vocat.Instantiated.Collections.Submission
		@render()

	navigateExhibitDetail: (event) ->
		data = @preventAndExtractData(event)
		path = 'courses/4/evaluations/creator/' + data.creator + '/project/' + data.project
		window.Vocat.router.navigate(path, true)

	navigateCreatorDetail: (event) ->
		data = @preventAndExtractData(event)
		path = 'courses/4/evaluations/creator/' + data.creator
		window.Vocat.router.navigate(path, true)

	navigateProjectDetail: (event) ->
		data = @preventAndExtractData(event)
		path = 'courses/4/evaluations/project/' + data.project
		window.Vocat.router.navigate(path, true)

	preventAndExtractData: (event) ->
		event.preventDefault()
		$(event.currentTarget).data()

	# This method creates the multidimensional hash we'll need to create
	# the grid. Normally, we would probably just do this in the view, but
	# since we're using logicless handlebar views, that's not an option.
#	prepareViewContext: () ->
#		rows = []
#		@creators.each (creator, creatorIndex) =>
#			row = {}
#			row.creator = creator.toJSON()
#			row.cells = []
#			@projects.each (project, projectIndex) =>
#				submission = _.first(@submissions.where({creator_id: creator.id, project_id: project.id}))
#				if submission?
#					submission = submission.toJSON()
#				cellData = {
#					project_id: project.id
#					submission: submission
#				}
#				row.cells.push cellData
#			rows.push row
#		context = {
#			projects: @projects.toJSON()
#			rows: rows
#		}

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



