class Vocat.Views.ExhibitList extends Backbone.View

	template: JST["backbone/templates/exhibit_list"]

	initialize: (options) ->
		@exhibitCollection = window.Vocat.Instantiated.Collections.Exhibit
		console.log @exhibitCollection.first()
		@render()

	render: () ->
		$(@el).html(@template())