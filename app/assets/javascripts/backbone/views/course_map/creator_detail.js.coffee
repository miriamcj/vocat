class Vocat.Views.CourseMapCreatorDetail extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/course_map/creator_detail"]

	initialize: (options) ->
		@courseId = options.courseId
		@projects = options.projects
		@creators = options.creators
		@creator = @creators.get(options.creator)

		@submissions = new Vocat.Collections.Submission({creatorId: @creator.id, courseId: @courseId})

		$.when(@submissions.fetch()).then () =>
			@render()

	render: () ->
		context = {
			creator: @creator.toJSON()
			projects: @projects.toJSON()
			submissions: @submissions.toJSON()
		}
		@$el.html(@template(context))

		childContainer = @$el.find('.js-submissions')
		@projects.each (project) =>
			submission = @submissions.where({project_id: project.id})[0]
			# TODO: Abstract this factory code for creating a submission from a project to somewhere else.
			if !submission?
				submission = new Vocat.Models.Submission({
					project_name: project.get('name')
					project_id: project.id
					creator_id: @creator.id
					creator_name: @creator.get('name')
					course_id: project.get('course_id')
					course_name: project.get('course_name')
					course_name_long: project.get('course_name_long')
				})
			childView = new Vocat.Views.PortfolioSubmissionSummary({
				el: $('<div class="constrained-portfolio-frame"></div>')
				model: submission
			})
			childContainer.append(childView.render())

		@$el.find('[data-behavior="dropdown"]').dropdownNavigation()


