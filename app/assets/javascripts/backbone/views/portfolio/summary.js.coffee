class Vocat.Views.PortfolioSubmissionSummary extends Vocat.Views.AbstractView

	ownerTemplate: HBT["backbone/templates/portfolio/submission_summary_owner"]
	otherTemplate: HBT["backbone/templates/portfolio/submission_summary_other"]

	initialize: (options) ->
		super (options)

	render: () ->
		context = {
		  submission: @model.toJSON()
		}

		# TODO: Switch view based on user type
		console
		template = @ownerTemplate
		@$el.html(template(context))
