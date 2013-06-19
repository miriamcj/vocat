define 'app/helpers/url_for', ['Handlebars'], (Handlebars) ->

  # This method is a wrapper around the javascript method produced
  # by the js-routes gem.
  Handlebars.registerHelper 'url_for', () ->
    args = Array.prototype.slice.call(arguments);
    routeMethodName = args.shift() + '_path'
    helperOptions = args.pop()
    routeMethodOptions = helperOptions.hash
    args.push routeMethodOptions
    if window.Vocat.Routes[routeMethodName]?
      routeMethod = window.Vocat.Routes[routeMethodName]
      out = routeMethod.apply(this, args)
    else
      out = ''
    return out