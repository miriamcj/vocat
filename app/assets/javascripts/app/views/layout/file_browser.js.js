define (require) ->
  Marionette = require('marionette')

  class FileBrowserView extends Marionette.ItemView

    events: {
      'click @ui.fileClear': 'clearFile'
      'change': 'updateDisplay'
    }

    ui: {
      fileClear: '[data-behavior="file-clear"]'
      fileDisplay: '[data-behavior="file-display"]'
      fileDelete: '[data-behavior="file-delete"]'
      avatarPreview: '[data-region="avatar-preview"]'
    }

    clearFile: () ->
      @fileDisplay.innerText = "Choose File..."
      @fileDelete.checked = true
      @avatarPreview.remove()

    updateDisplay: (event) ->
      @fileDisplay.innerHTML = event.target.files[0].name
      @fileDelete.checked = false

    initialize: (options) ->
      @vent = options.vent
      @fileDisplay = $(@ui.fileDisplay)[0]
      @fileDelete = $(@ui.fileDelete)[0]
      @avatarPreview = $(@ui.avatarPreview)[0]
