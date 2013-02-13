$ ->
  $('#fileupload').fileupload
    dataType: 'json'
    start: (e, data) ->
      $("#progress").text("File uploading...")
    complete: (e, data) ->
      $("#progress").text("Upload complete.")
      window.location.href = window.location.href
