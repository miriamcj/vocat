/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/assets/annotations/annotations_item_empty.hbs';

export default class AnnotationsEmptyView extends Marionette.ItemView {
  constructor(options) {
    super(options);

    this.template = template;
    this.tagName = 'li';
    this.className = 'annotation';
  }
};
