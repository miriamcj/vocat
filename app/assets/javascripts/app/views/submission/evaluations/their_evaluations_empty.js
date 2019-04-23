/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/submission/evaluations/their_evaluations_empty.hbs';

export default class TheirEvaluationsEmpty extends Marionette.ItemView {
  constructor(options) {
    super(options);

    this.template = template;
  }
};
