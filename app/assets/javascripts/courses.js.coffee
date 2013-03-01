$ ->
  $('#course_select').change ->
    id = $(@).val()
    if id
      re = /(course\/)(\d)+/
      # get url from data
      startUrl = $(@).data('url')
      # add course id within url? or just append it?
      if startUrl.match(re)
        replacer = (match, p1, p2) ->
          return p1+id
        url = $(@).data("url").replace(re, replacer)
      else
        url = startUrl + "/" + id
    else
      url = $(@).data("url")

    # redirect
    window.location.href = url
