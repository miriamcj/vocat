/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let GlobalFlashMessages;
  const AbstractFlashMessages = require('views/abstract/abstract_flash_messages');
  const template = require('hbs!templates/flash/global_flash_messages');
  require('waypoints_sticky');
  require('waypoints');

  return GlobalFlashMessages = (function() {
    GlobalFlashMessages = class GlobalFlashMessages extends AbstractFlashMessages {
      static initClass() {
  
        this.prototype.template = template;
      }
    };
    GlobalFlashMessages.initClass();
    return GlobalFlashMessages;
  })();
});
