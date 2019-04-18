/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let LongTextInput;
import ShortTextInput from 'views/property_editor/short_text_input';
import template from 'hbs!templates/property_editor/long_text_input';

export default LongTextInput = (function() {
  LongTextInput = class LongTextInput extends ShortTextInput {
    static initClass() {

      this.prototype.template = template;
    }
  };
  LongTextInput.initClass();
  return LongTextInput;
})();