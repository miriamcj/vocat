/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let ShortTextInput;
import Marionette from 'marionette';
import template from 'hbs!templates/property_editor/short_text_input';

export default ShortTextInput = (function() {
  ShortTextInput = class ShortTextInput extends Marionette.ItemView {
    static initClass() {

      this.prototype.template = template;

      this.prototype.ui = {
        input: '[data-property="input"]',
        errorContainer: '[data-behavior="error-container"]'
      };

      this.prototype.saveModelOnSave = false;
      this.prototype.onSave = null;
      this.prototype.inputLabel = 'Update Property';

      this.prototype.triggers = {
        'click [data-behavior="model-save"]': 'click:model:save',
        'click [data-behavior="cancel"]': 'click:model:cancel'
      };
    }

    onClickModelCancel() {
      return Vocat.vent.trigger('modal:close');
    }

    onClickModelSave() {
      this.save();
      if (_.isFunction(this.onSave)) {
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
        Vocat.vent.trigger('modal:close');
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
  };
  ShortTextInput.initClass();
  return ShortTextInput;
})();

