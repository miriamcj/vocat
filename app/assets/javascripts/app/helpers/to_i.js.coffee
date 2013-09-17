define 'app/helpers/to_i', ['handlebars'], (Handlebars) ->

  Handlebars.registerHelper "to_i", (value, options) ->
    unless isNaN(value)
      parseInt(value)
    else
      ''