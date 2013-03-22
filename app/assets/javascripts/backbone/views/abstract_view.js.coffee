class Vocat.Views.AbstractView extends Backbone.View

	template: HBT["backbone/templates/exhibit"]

	initialize: (options) ->
		if options.organizationId? then @organizationId = options.organizationId
