/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import template from 'hbs!templates/submission/evaluations/their_evaluations_empty';

export default TheirEvaluationsEmpty = (function() {
  TheirEvaluationsEmpty = class TheirEvaluationsEmpty extends Marionette.ItemView {
    static initClass() {

      this.prototype.template = template;
    }
  };
  TheirEvaluationsEmpty.initClass();
  return TheirEvaluationsEmpty;
})();
