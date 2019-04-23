/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/submission/evaluations/their_evaluations_collection.hbs';
import ChildView from 'views/submission/evaluations/their_evaluations_child';
import ExpandableRange from 'behaviors/expandable_range';

export default class TheirEvaluationsCollection extends Marionette.CompositeView {
  constructor() {

    this.template = template;
    this.className = 'evaluation-collection';
    this.tagName = 'li';
    this.childView = ChildView;
    this.childViewContainer = '[data-behavior="child-container"]:first';

    this.behaviors = {
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
