(function() {
  define('app/helpers/invert', ['handlebars'], function(Handlebars) {
    return Handlebars.registerHelper("invert", function(value, options) {
      return 100 - parseInt(value);
    });
  });

}).call(this);
