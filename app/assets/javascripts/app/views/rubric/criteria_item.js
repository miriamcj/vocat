/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/rubric/criteria_item.hbs';
import ShortTextInputView from 'views/property_editor/short_text_input';
import ModalConfirmView from 'views/modal/modal_confirm';

export default class CriteriaItem extends Marionette.ItemView {
  constructor(options) {
    super(options);

    this.template = template;
    this.className = 'criteria-item';

    this.triggers = {
      'click [data-behavior="destroy"]': 'model:destroy',
      'click [data-behavior="edit"]': 'click:edit',
      'click [data-behavior="move-up"]': 'click:up',
      'click [data-behavior="move-down"]': 'click:down'
    };
  }

  openModal() {
    const label = "What would you like to call this criteria?";
    return Vocat.vent.trigger('modal:open', new ShortTextInputView({
      model: this.model,
      inputLabel: label,
      saveLabel: 'Update Criteria Name',
      saveClasses: 'update-button',
      property: 'name',
      vent: this.vent
    }));
  }

  onModelDestroy() {
    return Vocat.vent.trigger('modal:open', new ModalConfirmView({
      model: this.model,
      vent: this,
      descriptionLabel: 'Deleting this criteria will also delete all descriptions associated with this criteria.',
      confirmEvent: 'confirm:model:destroy',
      dismissEvent: 'dismiss:model:destroy'
    }));
  }


  reindex(collection) {
    return collection.each((criteria, index) => criteria.set('index', index));
  }

  onClickEdit() {
    return this.openModal();
  }

  onClickUp() {
    this.collection.comparator = 'index';
    this.nextModel = this.collection.at(this.model.get('index') - 1);
    if (this.model.get('index') !== 0) {
      this.model.set('index', this.model.get('index') - 1);
      this.nextModel.set('index', this.model.get('index') + 1);
      return this.collection.sort();
    }
  }

  onClickDown() {
    this.collection.comparator = 'index';
    this.nextModel = this.collection.at(this.model.get('index') + 1);
    if (this.model.get('index') !== (this.collection.length - 1)) {
      this.model.set('index', this.model.get('index') + 1);
      this.nextModel.set('index', this.model.get('index') - 1);
      return this.collection.sort();
    }
  }

  onConfirmModelDestroy() {
    this.collection.remove(this.model);
    this.model.destroy();
    return this.reindex(this.collection);
  }

  initialize() {
    return this.listenTo(this.model, 'change:name', this.render, this);
  }
};
