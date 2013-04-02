$ ->
  $('#course_select').change ->
    url = $(@).val()
    window.location.href = url
