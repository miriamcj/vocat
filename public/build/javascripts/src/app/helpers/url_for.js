(function() {
  define('app/helpers/url_for', ['handlebars'], function(Handlebars) {
    return Handlebars.registerHelper('url_for', function() {
      var args, helperOptions, out, routeMethod, routeMethodName, routeMethodOptions;

      args = Array.prototype.slice.call(arguments);
      routeMethodName = args.shift() + '_path';
      helperOptions = args.pop();
      routeMethodOptions = helperOptions.hash;
      args.push(routeMethodOptions);
      if (window.Vocat.Routes[routeMethodName] != null) {
        routeMethod = window.Vocat.Routes[routeMethodName];
        out = routeMethod.apply(this, args);
      } else {
        out = '';
      }
      return out;
    });
  });

}).call(this);
