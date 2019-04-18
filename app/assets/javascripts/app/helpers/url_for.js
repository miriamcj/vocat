/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define('app/helpers/url_for', ['handlebars'], Handlebars =>

  // This method is a wrapper around the javascript method produced
  // by the js-routes gem.
  Handlebars.registerHelper('url_for', function() {
    let out;
    const args = Array.prototype.slice.call(arguments);
    const routeMethodName = args.shift() + '_path';
    const helperOptions = args.pop();
    const routeMethodOptions = helperOptions.hash;
    args.push(routeMethodOptions);
    if (window.Vocat.Routes[routeMethodName] != null) {
      const routeMethod = window.Vocat.Routes[routeMethodName];
      out = routeMethod.apply(this, args);
    } else {
      out = '';
    }
    return out;
  })
);