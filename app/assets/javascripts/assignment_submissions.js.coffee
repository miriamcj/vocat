$ ->
  $('#fileupload').fileupload
    dataType: 'json'
    progress: (e, data) ->
      progress = parseInt(data.loaded / data.total * 100, 10)
      $("#progress .bar").css "width", progress+"%"
