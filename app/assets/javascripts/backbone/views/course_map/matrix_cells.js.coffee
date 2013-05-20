class Vocat.Views.CourseMapMatrixCells extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/course_map/matrix_cells"]

	initialize: (options) ->
		@courseId = options.courseId
		@creators = options.creators
		@projects = options.projects
		@submissions = new Vocat.Collections.Submission([], {courseId: @courseId})
		$.when(@submissions.fetch()).then () =>
			@render()


	render: () ->
		context = {
			creators: @creators.toJSON()
			projects: @projects.toJSON()
			submissions: @submissions.toJSON()
		}
		@$el.html(@template(context))

		Vocat.Dispatcher.trigger('courseMap:redraw')

