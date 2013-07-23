(function() {
  define('app/helpers/get_submission', ['handlebars'], function(Handlebars) {
    return Handlebars.registerHelper('get_submission', function(submissions, creator, project, options) {
      var submission;

      submission = _.find(submissions, function(submission) {
        return submission.creator_id === creator.id && submission.project_id === project.id;
      });
      return options.fn(submission);
    });
  });

}).call(this);
