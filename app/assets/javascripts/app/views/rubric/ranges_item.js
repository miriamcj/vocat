/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'backbone.marionette';
import template from 'templates/rubric/ranges_item.hbs';
import LongTextInputView from 'views/property_editor/long_text_input';
import ModalConfirmView from 'views/modal/modal_confirm';

export default class RangesItem extends Marionette.ItemView {
  constructor() {

    this.template = template;
    this.className = 'cell';

    this.triggers = {
      'click [data-behavior="destroy"]': 'description:clear',
      'click [data-behavior="edit"]': 'click:edit'
    };
  }

  findModel() {
    const cells = this.rubric.get('cells');
    const model = cells.findWhere({field: this.criteria.get('id'), range: this.range.get('id')});
    return model;
  }

  cellName() {
    return this.rubricName = `${this.model.rangeModel.get('name')} ${this.model.fieldModel.get('name')}`;
  }

  serializeData() {
    const data = super.serializeData();
    if (this.model.rangeModel != null) { data.rangeName = this.model.rangeModel.get('name'); }
    if (this.model.fieldModel != null) { data.fieldName = this.model.fieldModel.get('name'); }
    data.cellName = this.cellName();
    return data;
  }

  onDescriptionClear() {
    return Vocat.vent.trigger('modal:open', new ModalConfirmView({
      model: this.model,
      vent: this,
      descriptionLabel: 'Clear description?',
      confirmEvent: 'confirm:description:clear',
      dismissEvent: 'dismiss:description:clear'
    }));
  }

  onConfirmDescriptionClear() {
    return this.model.unset('description');
  }

  onClickEdit() {
    return this.openModal();
  }

  openModal() {
    const label = `Description: ${this.model.rangeModel.get('name')} ${this.model.fieldModel.get('name')}`;
    return Vocat.vent.trigger('modal:open', new LongTextInputView({
      model: this.model,
      inputLabel: label,
      saveLabel: 'Update Description',
      saveClasses: 'update-button',
      property: 'description',
      vent: this.vent
    }));
  }

  initialize(options) {
    this.vent = options.vent;
    this.range = options.range;
    this.criteria = this.model;
    this.rubric = options.rubric;
    this.model = this.findModel();

    if (this.model != null) {
      this.listenTo(this.model, 'change', function() {
        return this.render();
      });
    }
    if (this.model.rangeModel != null) { this.listenTo(this.model.rangeModel, 'change:name', this.render, this); }
    if (this.model.fieldModel != null) { return this.listenTo(this.model.fieldModel, 'change:name', this.render, this); }
  }
};
