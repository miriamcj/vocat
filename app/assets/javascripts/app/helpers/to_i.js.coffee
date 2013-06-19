define 'app/helpers/to_i', ['Handlebars'], (Handlebars) ->

  Handlebars.registerHelper "to_i", (value, options) ->
    parseInt(value)
