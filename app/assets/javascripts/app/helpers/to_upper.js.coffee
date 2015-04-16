define 'app/helpers/to_upper', ['handlebars'], (Handlebars) ->
  Handlebars.registerHelper "to_upper", (str) ->
    str.toUpperCase() if str?
