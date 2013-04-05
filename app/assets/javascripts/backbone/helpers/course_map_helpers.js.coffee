Handlebars.registerHelper('get_submission', (submissions, creator, project, options) ->
	console.clear()
	console.log submissions, 'submissions'
	console.log creator, 'creator'
	console.log project, 'project'
	submission = _.find(submissions, (submission) ->
		submission.creator_id == creator.id && submission.project_id == project.id
	)
	options.fn(submission)
)