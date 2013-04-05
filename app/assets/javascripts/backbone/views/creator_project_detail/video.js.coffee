class Vocat.Views.CreatorProjectDetailVideo extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/creator_project_detail/video"]

	initialize: (options) ->
		super(options)
		@render()

	render: () ->
		context = {
		}
		@$el.html(@template(context))

