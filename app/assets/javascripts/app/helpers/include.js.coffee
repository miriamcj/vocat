define 'app/helpers/include', ['handlebars'], (Handlebars) ->

  Handlebars.registerHelper "include", (templatename, options) ->
    console.log options,'opts'
    partial = Handlebars.partials[templatename]
    #context = $.extend({}, @, options.hash)
    context = options.hash
    partial(context)
