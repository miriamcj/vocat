define 'app/helpers/truncate', ['handlebars'], (Handlebars) ->
  Handlebars.registerHelper('truncate', (str, len) ->
    if str.length > len
      new_str = str.substr 0, len + 1
      while new_str.length
        ch = new_str.substr(-1)
        new_str = new_str.substr(0, -1)
        if ch == ' '
          break
      if new_str == ''
        new_str = str.substr(0, len)
    else
      new_str = str
    return new_str + '...'
  )

