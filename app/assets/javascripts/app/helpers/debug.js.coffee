define 'app/helpers/debug', ['handlebars'], (Handlebars) ->

  Handlebars.registerHelper "debug", (value, options) ->

    switch options.hash.level
      when "warn" then level = "warn"
      when "error" then level = "error"
      else level = "log"

    if options.hash.label?
      label = options.hash.label
    else
      label = 'Handlebars Debug:'

    console[level] label, value