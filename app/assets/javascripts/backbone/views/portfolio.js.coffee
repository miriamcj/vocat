class Vocat.Views.Portfolio extends Vocat.Views.AbstractView

	initialize: (options) ->
		super (options)
		@submissionCollection = window.Vocat.Instantiated.Collections.Submission
		@render()

	render: () ->
		@submissionCollection.each (submission) =>
			childView = new Vocat.Views.PortfolioSubmissionSummary({model: submission})
			@$el.append(childView.render())


