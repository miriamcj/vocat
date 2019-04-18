/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
Handlebars.registerHelper('if_match', function(matchA, matchB, options) {
  if (matchA === matchB) {
    return options.fn(this);
  } else {
    return options.inverse(this);
  }
});