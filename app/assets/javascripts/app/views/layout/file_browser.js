/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */




export default class FileBrowserView extends Marionette.ItemView.extend({
  events: {
    'click @ui.fileClear': 'clearFile',
    'change': 'updateDisplay'
  },

  ui: {
    fileClear: '[data-behavior="file-clear"]',
    fileDisplay: '[data-behavior="file-display"]',
    fileDelete: '[data-behavior="file-delete"]',
    avatarPreview: '[data-region="avatar-preview"]'
  }
}) {
  clearFile() {
    this.fileDisplay.innerText = "Choose File...";
    this.fileDelete.checked = true;
    return this.avatarPreview.remove();
  }

  updateDisplay(event) {
    this.fileDisplay.innerHTML = event.target.files[0].name;
    return this.fileDelete.checked = false;
  }

  initialize(options) {
    this.vent = options.vent;
    this.fileDisplay = $(this.ui.fileDisplay)[0];
    this.fileDelete = $(this.ui.fileDelete)[0];
    return this.avatarPreview = $(this.ui.avatarPreview)[0];
  }
}
