class Vocat.Views.CourseMapCreatorProjectDetail extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/course_map/creator_project_detail"]

	initialize: (options) ->
		@render()

	render: () ->
		context = {

		}
		@$el.html(@template(context))


