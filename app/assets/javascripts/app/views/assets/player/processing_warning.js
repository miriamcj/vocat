/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let ProcessingWarningView;
import Marionette from 'marionette';
import template from 'hbs!templates/assets/player/processing_warning';

export default ProcessingWarningView = (function() {
  ProcessingWarningView = class ProcessingWarningView extends Marionette.ItemView {
    static initClass() {

      this.prototype.template = template;
    }
  };
  ProcessingWarningView.initClass();
  return ProcessingWarningView;
})();

