/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
Handlebars.registerHelper('if_include', function(theArray, theString, options) {
  if (_.indexOf(theArray, theString) !== -1) {
    return options.fn(this);
  } else {
    return options.inverse(this);
  }
});
