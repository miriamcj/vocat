/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let UtilityView;
  const Marionette = require('marionette');
  const template = require('hbs!templates/submission/utility/utility');

  return UtilityView = (function() {
    UtilityView = class UtilityView extends Marionette.ItemView {
      static initClass() {
  
        this.prototype.template = template;
      }

      initialize(options) {
        this.vent = Marionette.getOption(this, 'vent');
        return this.courseId = Marionette.getOption(this, 'courseId');
      }

      serializeData() {
        const data = super.serializeData();
        data.courseId = this.courseId;
        return data;
      }
    };
    UtilityView.initClass();
    return UtilityView;
  })();
});