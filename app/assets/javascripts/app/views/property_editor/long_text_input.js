/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import ShortTextInput from 'views/property_editor/short_text_input';
import template from 'templates/property_editor/long_text_input.hbs';

export default class LongTextInput extends ShortTextInput {
  constructor() {

    this.template = template;
  }
};