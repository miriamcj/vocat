/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let ProcessingWarningView;
  const Marionette = require('marionette');
  const template = require('hbs!templates/assets/player/processing_warning');

  return ProcessingWarningView = (function() {
    ProcessingWarningView = class ProcessingWarningView extends Marionette.ItemView {
      static initClass() {
  
        this.prototype.template = template;
      }
    };
    ProcessingWarningView.initClass();
    return ProcessingWarningView;
  })();
});

