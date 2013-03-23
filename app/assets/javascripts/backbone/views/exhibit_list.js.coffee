class Vocat.Views.ExhibitList extends Vocat.Views.AbstractView

	initialize: (options) ->
		super (options)
		@exhibitCollection = window.Vocat.Instantiated.Collections.Exhibit
		@render()

	render: () ->
		@exhibitCollection.each (exhibit) =>
			childView = new Vocat.Views.ExhibitListItem({model: exhibit, organizationId: @organizationId, currentUserRole: @currentUserRole})
			@$el.append(childView.render())


