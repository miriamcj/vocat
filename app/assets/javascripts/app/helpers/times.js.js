/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define('app/helpers/times', ['handlebars'], Handlebars =>
  Handlebars.registerHelper("times", function(n, block) {
    let accum = '';
    for (let i = 1, end = n; i <= end; i++) {
      accum += block.fn(i);
    }
    return accum;
  })
);
