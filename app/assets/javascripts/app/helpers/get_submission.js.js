define 'app/helpers/get_submission', ['handlebars'], (Handlebars) ->
  Handlebars.registerHelper('get_submission', (submissions, creator, project, options) ->
    submission = _.find(submissions, (submission) ->
      submission.creator_id == creator.id && submission.project_id == project.id
    )
    options.fn(submission)
  )