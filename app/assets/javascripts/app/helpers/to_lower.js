/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define('app/helpers/to_lower', ['handlebars'], Handlebars =>
  Handlebars.registerHelper("to_lower", str => str.toLowerCase())
);
