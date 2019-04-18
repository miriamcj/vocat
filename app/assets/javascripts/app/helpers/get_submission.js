/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
Handlebars.registerHelper('get_submission', function(submissions, creator, project, options) {
  const submission = _.find(submissions, submission => (submission.creator_id === creator.id) && (submission.project_id === project.id));
  return options.fn(submission);
});