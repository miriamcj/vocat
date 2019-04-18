/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import $ from 'jquery_rails';

import Marionette from 'marionette';

export default FileInputView = (function() {
  FileInputView = class FileInputView extends Marionette.ItemView {
    static initClass() {

      this.prototype.ui = {
        trigger: '[data-behavior="file-input-trigger"]',
        field: '[data-behavior="file-input-field"]',
        mask: '[data-behavior="file-input-mask"]'
      };

      this.prototype.triggers = {
        'click @ui.trigger': 'trigger:click',
        'change @ui.field': 'mask:update'
      };
    }

    onMaskUpdate() {
      const val = $(this.ui.field).val();
      const newVal = val.replace(/^C:\\fakepath\\/i, '');
      return $(this.ui.mask).val(newVal);
    }

    onTriggerClick() {
      return $(this.ui.field).click();
    }
  };
  FileInputView.initClass();
  return FileInputView;
})();


