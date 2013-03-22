class Vocat.Views.ExhibitDetail_Video extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/exhibit_detail/video"]

	initialize: (options) ->
		super(options)
		@render()

	render: () ->
		context = {
			exhibit: @model.toJSON()
		}
		@$el.html(@template(context))

