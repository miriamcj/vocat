/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/submission/evaluations/my_evaluations_create.hbs';

export default class MyEvaluationsCreate extends Marionette.ItemView {
  constructor() {

    this.template = template;

    this.triggers =
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
