class Vocat.Views.AbstractView extends Backbone.View

  # TODO: Confirm whether or not this can be removed. Organization ID is no longer as important as it was during early VOCAT development.
	initialize: (options) ->
		if options.organizationId? then @organizationId = options.organizationId
