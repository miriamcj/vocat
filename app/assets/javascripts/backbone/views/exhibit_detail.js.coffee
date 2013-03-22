class Vocat.Views.ExhibitDetail extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/exhibit_detail"]

	initialize: (options) ->
		@collection = window.Vocat.Instantiated.Collections.Exhibit
		@model = @collection.first()
		@childViews = {}
		super(options)
		@render()

	render: () ->
		context = {
			exhibit: @model.toJSON()
		}
		out = @$el.html(@template(context))
		@childViews.video = new Vocat.Views.ExhibitDetail_Video({model: @model, el: $('#video-view')})
		@childViews.score = new Vocat.Views.ExhibitDetail_Score({model: @model, el: $('#score-view')})
		@childViews.discussion = new Vocat.Views.ExhibitDetail_Discussion({model: @model, el: $('#discussion-view')})
		out
