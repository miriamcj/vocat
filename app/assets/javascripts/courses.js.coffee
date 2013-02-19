$ ->
  $('#course_select').change ->
    id = $(@).val()
    if id
      url = $(@).data("url") + "/" + id
      window.location.href = url
    else
      window.location.href = $(@).data("url")