/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define('app/helpers/invert', ['handlebars'], Handlebars =>
  Handlebars.registerHelper("invert", (value, options) => 100 - parseInt(value))
);
