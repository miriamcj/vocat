class Vocat.Views.ExhibitList extends Backbone.View

	# Roles can be owner or not_owner
	currentUserRole: 'not_owner'

	initialize: (options) ->
		@organizationId = options.organizationId
		if options.currentUserRole? then @currentUserRole = options.currentUserRole
		@exhibitCollection = window.Vocat.Instantiated.Collections.Exhibit
		@render()

	render: () ->
		@exhibitCollection.each (exhibit) =>
			childView = new Vocat.Views.Exhibit({model: exhibit, organizationId: @organizationId, currentUserRole: @currentUserRole})
			@$el.append(childView.render())


