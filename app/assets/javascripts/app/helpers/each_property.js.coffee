define 'app/helpers/each_property', ['handlebars'], (Handlebars) ->

  Handlebars.registerHelper "each_property", (context, options) ->
    rubric = options.hash.rubric
    if options.hash.high?
      high = parseInt(options.hash.high)

    ret = ""
    _.each(context, (value, prop) ->
      val = context[prop]
      if high? && value?
        per = parseInt(parseFloat(value / high) * 100)
      else
        per = null

      field = _.findWhere(rubric.fields, {id: String(prop)})
      if field?
        name = field.name
      else
        name = prop
      ret = ret + options.fn({property: prop, name: name, value: value, per: per})
    )
    ret