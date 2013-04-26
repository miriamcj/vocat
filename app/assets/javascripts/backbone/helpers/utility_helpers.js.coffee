Handlebars.registerHelper "debug", (value, options) ->

  switch options.hash.level
    when "warn" then level = "warn"
    when "error" then level = "error"
    else level = "log"

  if options.hash.label?
    label = options.hash.label
  else
    label = 'Handlebars Debug:'

  console[level] label, value

Handlebars.registerHelper "to_i", (value, options) ->
  parseInt(value)


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

Handlebars.registerHelper('if_blank', (item, block) ->
	if (item and item.replace(/\s/g, "").length) then block.inverse(@) else block.fn(@)
)

