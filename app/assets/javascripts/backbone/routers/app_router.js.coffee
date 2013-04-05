# The dispatcher is a global application object.
Vocat.Dispatcher = new Vocat.Models.Dispatcher()

class Vocat.Routers.AppRouter extends Backbone.Router

	routes:
		"courses/:course/evaluations": 'showGrid'
		"courses/:course/evaluations/creator/:creator": 'showCreatorDetail'
		"courses/:course/evaluations/project/:project": 'showProjectDetail'
		"courses/:course/evaluations/creator/:creator/project/:project": 'showCreatorProjectDetail'

	initalize: (options) ->
		# We create all of our parent views based on the data-view attributes of the elements on the page
		@bootstrapCollections()
		@createViews()

	bootstrapCollections: () ->
		_.each(window.Vocat.Bootstrap.Collections, (collectionData, collectionName) =>
			if window.Vocat.Instantiated.Collections[collectionName]?
				window.Vocat.Instantiated.Collections[collectionName].reset(collectionData)
			else
				window.Vocat.Instantiated.Collections[collectionName] = new Vocat.Collections[collectionName](collectionData)
		)

	createViews: (el) ->

		$('[data-view]').each((i, el) =>
			$el = $(el)
			viewName = $el.attr('data-view')
			options = {
				el: $(el)
			}
			window.Vocat.Instantiated.Views[viewName] = new Vocat.Views[viewName](options)
		)

