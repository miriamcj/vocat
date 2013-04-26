class Vocat.Views.PortfolioSubmissionSummary extends Vocat.Views.AbstractView

	ownerTemplate: HBT["backbone/templates/portfolio/submission_summary_owner"]
	otherTemplate: HBT["backbone/templates/portfolio/submission_summary_other"]
	scorePartial: HBT["backbone/templates/partials/portfolio_score"]

	initialize: (options) ->
		super (options)

	render: () ->
		context = {
		  submission: @model.toJSON()
		}

		# TODO: Switch view based on user type
		if @model.get('current_user_is_owner')
			template = @ownerTemplate
		else
			template = @otherTemplate
		template = template
		Handlebars.registerPartial('portfolio_score', @scorePartial);
		@$el.html(template(context))
