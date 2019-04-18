/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
Handlebars.registerHelper('if_even', function(conditional, options) {
  if ((conditional % 2) === 0) {
    return options.fn(this);
  } else {
    return options.inverse(this);
  }
});