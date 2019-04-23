/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/rubric/ranges_empty.hbs';

export default class RangesEmptyView extends Marionette.ItemView {
  constructor() {

    this.template = template;
    this.tagName = 'th';
    this.attributes = {
      'data-match-height-source': ''
    };
  }

  initialize(options) {}
};


