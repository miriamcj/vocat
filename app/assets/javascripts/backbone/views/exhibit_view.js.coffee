class Vocat.Views.Exhibit extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/exhibit"]

	currentUseRole: 'not_owner'

	initialize: (options) ->
		console.log @model.attributes
		super (options)


	render: () ->
		context = {
		  exhibit: @model.toJSON()
		  organizationId: @organizationId
		}
		@$el.html(@template(context))
