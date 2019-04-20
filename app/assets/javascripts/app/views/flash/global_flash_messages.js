/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import AbstractFlashMessages from 'views/abstract/abstract_flash_messages';
import template from 'templates/flash/global_flash_messages.hbs';
const Waypoints = require("waypoints");
const WaypointsSticky = require("waypoints_sticky");

export default class GlobalFlashMessages extends AbstractFlashMessages {
  constructor() {

    this.template = template;
  }
};
