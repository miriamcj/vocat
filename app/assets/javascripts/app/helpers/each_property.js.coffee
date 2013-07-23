define 'app/helpers/each_property', ['handlebars'], (Handlebars) ->

  Handlebars.registerHelper "each_property", (context, options) ->

    if options.hash.high?
      high = parseInt(options.hash.high)

    ret = ""
    _.each(context, (value, prop) ->
      val = context[prop]
      if high? && value?
        per = parseInt(parseFloat(value / high) * 100)
      else
        per = null

      ret = ret + options.fn({property: prop, value: value, per: per})
    )
    ret