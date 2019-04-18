/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import template from 'hbs!templates/submission/evaluations/my_evaluations_create';

export default MyEvaluationsCreate = (function() {
  MyEvaluationsCreate = class MyEvaluationsCreate extends Marionette.ItemView {
    static initClass() {

      this.prototype.template = template;

      this.prototype.triggers =
        {'click [data-behavior="create-evaluation"]': 'evaluation:new'};
    }

    onEvaluationNew() {
      return this.vent.triggerMethod('evaluation:new');
    }

    initialize(options) {
      this.vent = options.vent;
      return this.rubric = options.rubric;
    }
  };
  MyEvaluationsCreate.initClass();
  return MyEvaluationsCreate;
})();
