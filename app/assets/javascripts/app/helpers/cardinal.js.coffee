define 'app/helpers/cardinal', ['handlebars'], (Handlebars) ->

  Handlebars.registerHelper "cardinal", (value, capitalize = false) ->
    out = value
    unless isNaN(value)
      n = parseInt(value)
      switch n
        when 1 then out = 'one'
        when 2 then out = 'two'
        when 3 then out = 'three'
        when 4 then out = 'four'
        when 5 then out = 'five'
        when 6 then out = 'six'
        when 7 then out = 'seven'
        when 8 then out = 'eight'
        when 9 then out = 'nine'
        when 10 then out = 'ten'
    if capitalize == true && _.isString(out)
      out = out.replace(/\w\S*/g, (txt) -> txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase())
    out
