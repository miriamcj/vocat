class Vocat.Routers.AppRouter extends Backbone.Router

#	routes:
#		"*catchall"			: ""

	initalize: (options) ->
		# We create all of our parent views based on the data-view attributes of the elements on the page
		@createViews()
		@bootstrapCollections()

	bootstrapCollections: () ->
		_.each(window.Vocat.Bootstrap.Collections, (collectionData, collectionName) =>
			if window.Vocat.Instantiated.Collections[collectionName]?
				window.Vocat.Instantiated.Collections[collectionName].reset(collectionData)
			else
				window.Vocat.Instantiated.Collections[collectionName] = new window.Vocat.Collections[collectionName](collectionData)
		)

	createViews: (el) ->
		$('[data-view]').each((i, el) =>
			$el = $(el)
			viewName = $el.attr('data-view')
			window.Vocat.Instantiated.Views[viewName] = new window.Vocat.Views[viewName]({el: $(el)})
		)

