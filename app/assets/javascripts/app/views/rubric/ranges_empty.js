/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/rubric/ranges_empty.hbs';

export default class RangesEmptyView extends Marionette.ItemView.extend({
  template: template,
  tagName: 'th',

  attributes: {
    'data-match-height-source': ''
  }
}) {
  initialize(options) {}
};
