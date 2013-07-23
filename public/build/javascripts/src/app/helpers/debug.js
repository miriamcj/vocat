(function() {
  define('app/helpers/debug', ['handlebars'], function(Handlebars) {
    return Handlebars.registerHelper("debug", function(value, options) {
      var label, level;

      switch (options.hash.level) {
        case "warn":
          level = "warn";
          break;
        case "error":
          level = "error";
          break;
        default:
          level = "log";
      }
      if (options.hash.label != null) {
        label = options.hash.label;
      } else {
        label = 'Handlebars Debug:';
      }
      return console[level](label, value);
    });
  });

}).call(this);
