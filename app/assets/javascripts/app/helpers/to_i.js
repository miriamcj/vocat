/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
Handlebars.registerHelper("to_i", function(value, options) {
  if (!isNaN(value) && (value !== null)) {
    return parseInt(value);
  } else {
    return 0;
  }
});
