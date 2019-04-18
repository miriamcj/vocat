/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let Warning;
const template = require('hbs!templates/group/warning');

export default Warning = (function() {
  Warning = class Warning extends Marionette.ItemView {
    static initClass() {

      this.prototype.template = template;
    }

    serializeData() {
      return {
      courseId: Marionette.getOption(this, 'courseId')
      };
    }
  };
  Warning.initClass();
  return Warning;
})();