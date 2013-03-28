class Vocat.Views.ExhibitDetail extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/exhibit_detail"]

	initialize: (options) ->
		console.log 'called'
		super(options)
		@collection = window.Vocat.Instantiated.Collections.Exhibit
		@model = @collection.first()
		@render()

	render: () ->

		context = {
			exhibit: @model.toJSON()
		}

		@$el.html(@template(context))

		new Vocat.Views.ExhibitDetailVideo({model: @model, el: $('#video-view')})
		new Vocat.Views.ExhibitDetailScore({model: @model, el: $('#score-view')})
		new Vocat.Views.ExhibitDetailDiscussion({model: @model, el: $('#discussion-view')})
