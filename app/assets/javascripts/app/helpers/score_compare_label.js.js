/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define('app/helpers/score_compare_label', ['handlebars'], Handlebars =>
  Handlebars.registerHelper("score_compare_label", function(value, options) {
    switch (value) {
      case 'my-scores': return 'My Scores';
      case 'instructor-scores': return 'Instructor Scores';
      case 'peer-scores': return 'Peer Scores';
      case 'self-scores': return 'Self Evaluation Scores';
      case 'rubric-scores': return 'Rubic Scores';
      default: return value;
    }
  })
);
