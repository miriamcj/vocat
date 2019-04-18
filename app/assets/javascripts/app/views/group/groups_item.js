/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let GroupsItem;
const Marionette = require('marionette');
const template = require('hbs!templates/group/groups_item');
const ModalConfirmView = require('views/modal/modal_confirm');
const ShortTextInputView = require('views/property_editor/short_text_input');

export default GroupsItem = (function() {
  GroupsItem = class GroupsItem extends Marionette.ItemView {
    static initClass() {

      this.prototype.tagName = 'th';
      this.prototype.className = 'matrix--fullbleed';
      this.prototype.template = template;

      this.prototype.attributes = {
        'data-behavior': 'navigate-group',
        'data-match-height-source': ''
      };

      this.prototype.triggers = {
        'click [data-behavior="destroy"]': 'click:destroy',
        'click [data-behavior="edit"]': 'click:edit'
      };
    }

    onClickEdit() {
      const onSave = () => {
        // Tell the parent layout that its dirty and needs to save.
        return this.vent.triggerMethod('dirty');
      };
      return Vocat.vent.trigger('modal:open', new ShortTextInputView({
        model: this.model,
        vent: this.vent,
        onSave,
        property: 'name',
        saveLabel: 'Update group name',
        inputLabel: 'What would you like to call this group?'
      }));
    }


    onConfirmDestroy() {
      return this.model.destroy({
        success: () => {
          Vocat.vent.trigger('error:clear');
          return Vocat.vent.trigger('error:add',
            {level: 'notice', lifetime: '3000', msg: 'The group was successfully deleted.'});
        }
        , error: () => {
          Vocat.vent.trigger('error:clear');
          return Vocat.vent.trigger('error:add', {level: 'notice', msg: xhr.responseJSON.errors});
        }
      });
    }

    onClickDestroy() {
      return Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: this.model,
        vent: this,
        descriptionLabel: 'Deleting this group will also delete any submissions and evaluations owned by this group.',
        confirmEvent: 'confirm:destroy',
        dismissEvent: 'dismiss:destroy'
      }));
    }

    serializeData() {
      const data = super.serializeData();
      data.courseId = this.options.courseId;
      return data;
    }

    initialize(options) {
      this.vent = options.vent;
      this.$el.attr('data-group', this.model.id);

      return this.listenTo(this.model, 'change:name', () => {
        this.render();
        return this.vent.trigger('recalculate');
      });
    }
  };
  GroupsItem.initClass();
  return GroupsItem;
})();
