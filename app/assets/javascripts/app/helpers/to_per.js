/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
Handlebars.registerHelper("to_per", function(value, options) {
  if (!isNaN(value) && (value !== null)) {
    return parseInt(value.toFixed(2) * 100);
  } else {
    return 0;
  }
});
