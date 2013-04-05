class Vocat.Views.EvaluationDetail extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/course_map/creator_project_detail"]


	initialize: (options)  ->
		@render()

	render: () ->
		@$el.html(@template({}))






