class Vocat.Views.ExhibitList extends Backbone.View

	template: JST["backbone/templates/exhibit_list"]

	initialize: (options) ->
		@exhibitCollection = window.Vocat.Instantiated.Collections.Exhibit
		@role = @$el.data('role')
		@render()

	render: () ->
		@$el.html(@template({}))
		@exhibitCollection.each( (exhibit) =>
			if @role == 'creator'
				childView = new Vocat.Views.UnevaluatableExhibit({model: exhibit})
			else
				childView = new Vocat.Views.EvaluatableExhibit({model: exhibit})
			@$el.append(childView.render())

		)
