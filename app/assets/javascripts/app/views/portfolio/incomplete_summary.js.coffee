class Vocat.Views.PortfolioIncompleteSummary extends Vocat.Views.AbstractView

	template: HBT["app/templates/portfolio/incomplete_summary_owner"]
	scorePartial: HBT["app/templates/partials/score_summary"]

	defaults: {
		showCourse: true
		showCreator: true
	}

	initialize: (options) ->
		options = _.extend(@defaults, options)
		super (options)

	render: () ->
		context = {
			project: @model.toJSON()
			showCourse: @options.showCourse
			showCreator: @options.showCreator
		}

		Handlebars.registerPartial('score_summary', @scorePartial);
		@$el.html(@template(context))
