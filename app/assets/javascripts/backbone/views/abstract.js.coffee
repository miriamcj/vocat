class Vocat.Views.AbstractView extends Backbone.View

	initialize: (options) ->
		if options.organizationId? then @organizationId = options.organizationId
