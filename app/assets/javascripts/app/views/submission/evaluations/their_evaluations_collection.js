/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let TheirEvaluationsCollection;
import Marionette from 'marionette';
import template from 'hbs!templates/submission/evaluations/their_evaluations_collection';
import ChildView from 'views/submission/evaluations/their_evaluations_child';
import ExpandableRange from 'behaviors/expandable_range';

export default TheirEvaluationsCollection = (function() {
  TheirEvaluationsCollection = class TheirEvaluationsCollection extends Marionette.CompositeView {
    static initClass() {

      this.prototype.template = template;
      this.prototype.className = 'evaluation-collection';
      this.prototype.tagName = 'li';
      this.prototype.childView = ChildView;
      this.prototype.childViewContainer = '[data-behavior="child-container"]:first';

      this.prototype.behaviors = {
        expandableRange: {
          behaviorClass: ExpandableRange
        }
      };
    }
    childViewOptions() {
      return {
      rubric: this.rubric
      };
    }

    className() {
      return `evaluation-collection evaluation-collection-${this.model.get('evaluator_role').toLowerCase()}`;
    }

    initialize(options) {
      this.collection = this.model.get('evaluations');
      return this.rubric = options.rubric;
    }

    serializeData() {
      return {
      title: `${this.model.get('evaluator_role')} Evaluations`,
      percentage: this.model.averageScore(),
      range_class: 'range-expandable'
      };
    }
  };
  TheirEvaluationsCollection.initClass();
  return TheirEvaluationsCollection;
})();
