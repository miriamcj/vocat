/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/group/groups_item.hbs';
import ModalConfirmView from 'views/modal/modal_confirm';
import ShortTextInputView from 'views/property_editor/short_text_input';

export default class GroupsItem extends Marionette.ItemView.extend({
  tagName: 'th',
  className: 'matrix--fullbleed',
  template: template,

  attributes: {
    'data-behavior': 'navigate-group',
    'data-match-height-source': ''
  },

  triggers: {
    'click [data-behavior="destroy"]': 'click:destroy',
    'click [data-behavior="edit"]': 'click:edit'
  }
}) {
  onClickEdit() {
    const onSave = () => {
      // Tell the parent layout that its dirty and needs to save.
      return this.vent.triggerMethod('dirty');
    };
    return window.Vocat.vent.trigger('modal:open', new ShortTextInputView({
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
        window.Vocat.vent.trigger('error:clear');
        return window.Vocat.vent.trigger('error:add',
          {level: 'notice', lifetime: '3000', msg: 'The group was successfully deleted.'});
      }
      , error: () => {
        window.Vocat.vent.trigger('error:clear');
        return window.Vocat.vent.trigger('error:add', {level: 'notice', msg: xhr.responseJSON.errors});
      }
    });
  }

  onClickDestroy() {
    return window.Vocat.vent.trigger('modal:open', new ModalConfirmView({
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