/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import AbstractFlashMessages from 'views/abstract/abstract_flash_messages';
import template from 'hbs!templates/flash/global_flash_messages';
import 'waypoints_sticky';
import 'waypoints';

export default class GlobalFlashMessages extends AbstractFlashMessages {
  constructor() {

    this.template = template;
  }
};
