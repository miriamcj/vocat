define 'app/helpers/to_lower', ['handlebars'], (Handlebars) ->

  Handlebars.registerHelper "to_lower", (str) ->
    str.toLowerCase()
