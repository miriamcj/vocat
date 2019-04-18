/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define('app/helpers/calc_low', ['handlebars'], Handlebars =>
  Handlebars.registerHelper('calc_low', function(ranges, low_bound) {
    if (ranges.length > 0) {
      return (low_bound + ranges.length) - 1;
    } else {
      return low_bound + 1;
    }
  })
);
