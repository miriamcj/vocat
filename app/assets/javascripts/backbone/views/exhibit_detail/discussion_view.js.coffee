class Vocat.Views.ExhibitDetail_Discussion extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/exhibit_detail/discussion"]

	initialize: (options) ->
		super(options)
		@render()

	render: () ->
		context = {
			exhibit: @model.toJSON()
		}
		@$el.html(@template(context))

