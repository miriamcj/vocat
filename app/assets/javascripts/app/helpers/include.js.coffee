define 'app/helpers/include', ['handlebars'], (Handlebars) ->

  Handlebars.registerHelper "include", (templatename, options) ->
    partial = Handlebars.partials[templatename]
    context = options.hash
    partial(context)
