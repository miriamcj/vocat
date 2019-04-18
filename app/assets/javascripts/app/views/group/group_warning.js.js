/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let GroupWarning;
  const template = require('hbs!templates/group/group_warning');

  return GroupWarning = (function() {
    GroupWarning = class GroupWarning extends Marionette.ItemView {
      static initClass() {
  
        this.prototype.template = template;
  
        this.prototype.triggers = {
          'click @ui.createGroup': 'click:group:add'
        };
  
        this.prototype.ui = {
          createGroup: '[data-behavior="create-group"]'
        };
      }

      onClickGroupAdd() {
        return this.vent.triggerMethod('click:group:add');
      }

      initialize(options) {
        return this.vent = options.vent;
      }

      serializeData() {
        return {
        courseId: Marionette.getOption(this, 'courseId')
        };
      }
    };
    GroupWarning.initClass();
    return GroupWarning;
  })();});
