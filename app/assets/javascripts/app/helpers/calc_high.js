/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
Handlebars.registerHelper('calc_high', function(ranges, high_bound) {
  if (ranges.length > 0) {
    return (high_bound - ranges.length) + 1;
  } else {
    return high_bound - 1;
  }
});
