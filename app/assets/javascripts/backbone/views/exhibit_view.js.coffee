class Vocat.Views.Exhibit extends Backbone.View

	template: HBT["backbone/templates/exhibit"]

	currentUseRole: 'not_owner'

	initialize: (options) ->
		@organizationId = options.organizationId
		if options.currentUserRole? then @currentUseRole = options.currentUseRole

	render: () ->
		context = {
		  exhibit: @model.toJSON()
		  organizationId: @organizationId
		}
		console.log context
		@$el.html(@template(context))
