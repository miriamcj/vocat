class Vocat.Views.Portfolio extends Vocat.Views.AbstractView

	initialize: (options) ->
		super (options)
		@submissionCollection = window.Vocat.Instantiated.Collections.Submission
		if window.Vocat.Instantiated.Collections.Project?
			@incompleteProjectCollection = window.Vocat.Instantiated.Collections.Project
		else
			@incompleteProjectCollection = new Vocat.Collections.Project
		@render()

	render: () ->
		@submissionCollection.each (submission) =>
			targetEl = $('<div class="portfolio-frame"></div>')
			childView = new Vocat.Views.PortfolioSubmissionSummary({model: submission, el: targetEl})
			@$el.append(childView.render())

		@incompleteProjectCollection.each (project) =>
			targetEl = $('<div class="portfolio-frame"></div>')
			childView = new Vocat.Views.PortfolioIncompleteSummary({model: project, el: targetEl})
			@$el.append(childView.render())



