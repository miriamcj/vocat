/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import { isFunction } from "lodash";
import template from 'templates/property_editor/short_text_input.hbs';

export default class ShortTextInput extends Marionette.ItemView.extend({
  template: template,

  ui: {
    input: '[data-property="input"]',
    errorContainer: '[data-behavior="error-container"]'
  },

  saveModelOnSave: false,
  onSave: null,
  inputLabel: 'Update Property',

  triggers: {
    'click [data-behavior="model-save"]': 'click:model:save',
    'click [data-behavior="cancel"]': 'click:model:cancel'
  }
}) {
  onClickModelCancel() {
    return window.Vocat.vent.trigger('modal:close');
  }

  onClickModelSave() {
    this.save();
    if (isFunction(this.onSave)) {
      return this.onSave();
    }
  }

  getValue() {
    return this.ui.input.val();
  }

  save() {
    const attr = {};
    attr[this.property] = this.getValue();

    // Save or set
    if (Marionette.getOption(this, "saveModelOnSave") === true) {
      this.model.save(attr, {validate: true});
    } else {
      this.model.set(attr, {validate: true});
    }

    // Check if valid
    if (this.model.isValid()) {
      window.Vocat.vent.trigger('modal:close');
      return this.trigger('model:updated');
    } else {
      const error = this.model.validationError;
      return this.updateError(error);
    }
  }

  updateError(error) {
    this.ui.errorContainer.html(error);
    return this.ui.errorContainer.show();
  }

  initialize(options) {
    this.property = options.property;
    this.vent = options.vent;
    return this.onSave = Marionette.getOption(this, "onSave");
  }


  serializeData() {
    return {
    value: this.model.get(this.property),
    label: Marionette.getOption(this, "inputLabel"),
    saveClasses: Marionette.getOption(this, "saveClasses"),
    saveLabel: Marionette.getOption(this, "saveLabel")
    };
  }

  onRender() {
    const input = this.$el.find('[data-property="input"]');
    return setTimeout(() => input.focus()
    , 0);
  }
}