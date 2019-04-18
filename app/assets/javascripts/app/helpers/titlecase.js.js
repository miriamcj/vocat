define 'app/helpers/titlecase', ['handlebars'], (Handlebars) ->
  Handlebars.registerHelper "titlecase", (str) ->
    str.replace(/\w\S*/g, (txt) -> txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase())
