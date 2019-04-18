/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define('app/helpers/to_upper', ['handlebars'], Handlebars =>
  Handlebars.registerHelper("to_upper", function(str) {
    if (str != null) { return str.toUpperCase(); }
  })
);
