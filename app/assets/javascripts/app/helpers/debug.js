/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define('app/helpers/debug', ['handlebars'], Handlebars =>
  Handlebars.registerHelper("debug", function(value, options) {
    let label, level;
    switch (options.hash.level) {
      case "warn": level = "warn"; break;
      case "error": level = "error"; break;
      default:
        level = "log";
    }

    if (options.hash.label != null) {
      ({ label } = options.hash);
    } else {
      label = 'Handlebars Debug:';
    }

    return console[level](label, value);
  })
);