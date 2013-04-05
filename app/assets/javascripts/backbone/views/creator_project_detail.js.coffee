class Vocat.Views.CreatorProjectDetail extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/creator_project_detail"]

	initialize: (options) ->
		console.log 'called'
		super(options)
		#@collection = window.Vocat.Instantiated.Collections.Exhibit
		#@model = @collection.first()
		@render()

	render: () ->

		context = {

		}

		@$el.html(@template(context))

		new Vocat.Views.CreatorProjectDetailVideo({model: @model, el: $('#video-view')})
		new Vocat.Views.CreatorProjectDetailScore({model: @model, el: $('#score-view')})
		new Vocat.Views.CreatorProjectDetailDiscussion({model: @model, el: $('#discussion-view')})
