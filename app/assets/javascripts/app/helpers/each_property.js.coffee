define 'app/helpers/each_property', ['Handlebars'], (Handlebars) ->

  Handlebars.registerHelper "each_property", (context, options) ->

    ret = ""
    console.log context,'context'
    _.each(context, (value, prop) ->
      ret = ret + options.fn({property: prop, value: context[prop]})
    )
    ret