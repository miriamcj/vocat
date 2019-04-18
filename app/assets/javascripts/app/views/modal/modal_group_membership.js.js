/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let ModalGroupMembershipView;
  const Marionette = require('marionette');
  const template = require('hbs!templates/modal/modal_group_membership');
  const GroupModel = require('models/group');

  return ModalGroupMembershipView = (function() {
    ModalGroupMembershipView = class ModalGroupMembershipView extends Marionette.ItemView {
      static initClass() {
  
        this.prototype.template = template;
  
        this.prototype.triggers = {
          'click [data-behavior="dismiss"]': 'click:dismiss'
        };
      }

      onKeyUp(e) {
        const code = (e.keyCode != null) ? e.keyCode : e.which;
        if (code === 27) { return this.onClickDismiss(); }
      }


      onClickDismiss() {
        return Vocat.vent.trigger('modal:close');
      }

      onDestroy() {
        return $(window).off('keyup', this.onKeyUp);
      }

      initialize(options) {
        _.bindAll(this, 'onKeyUp');
        $(window).on('keyup', this.onKeyUp);
        const { groupId } = options;
        this.model = new GroupModel({id: groupId});
        return this.model.fetch({
          success: () => {
            return this.render();
          }
        });
      }
    };
    ModalGroupMembershipView.initClass();
    return ModalGroupMembershipView;
  })();
});
