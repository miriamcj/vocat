(function() {
  define('app/helpers/to_i', ['handlebars'], function(Handlebars) {
    return Handlebars.registerHelper("to_i", function(value, options) {
      return parseInt(value);
    });
  });

}).call(this);
