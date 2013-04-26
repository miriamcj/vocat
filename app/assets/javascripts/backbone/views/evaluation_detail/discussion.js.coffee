class Vocat.Views.EvaluationDetailDiscussion extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/evaluation_detail/discussion"]

	initialize: (options) ->
		super(options)
		@render()

	render: () ->
		context = {
		}
		@$el.html(@template(context))

