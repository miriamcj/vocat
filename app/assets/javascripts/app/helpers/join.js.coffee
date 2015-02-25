define 'app/helpers/join', ['handlebars'], (Handlebars) ->

  Handlebars.registerHelper "join", (value, options) ->

    # Clone it.
    value = value.slice(0)

    separator = options.hash.separator || ', '
    lastSeparator = options.hash.lastSeparator || 'and '
    leadingIndefiniteArticle = options.hash.leadingIndefiniteArticle || false
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

      if leadingIndefiniteArticle == true
        first = out[0].toLowerCase()
        if first == 'a' || first == 'e' || first == 'i' || first == 'o' || first == 'u' || first == 'y'
          article = 'an'
        else
          article = 'a'
        out = "#{article} #{out}"

      out

    else
      value
