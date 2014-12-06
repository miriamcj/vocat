define 'app/helpers/join', ['handlebars'], (Handlebars) ->

  Handlebars.registerHelper "join", (value, options) ->
    separator = ', '
    lastSeparator = 'and '
    capitalize = options.hash.capitalize || false

    if _.isArray(value)

      if capitalize
        value = _.map(value, (theString) ->
          theString.charAt(0).toUpperCase() + theString.slice(1);
        )

      length = value.length

      if length > 1
        last = value.pop()

      out = value.join(separator)

      if length == 2
        out = out + ' ' + lastSeparator + last
      if length > 2
        out = out + separator + lastSeparator + last

      out
    else
      value
