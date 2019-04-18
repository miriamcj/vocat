/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import template from 'hbs!templates/rubric/range';
import ItemView from 'views/rubric/ranges_item';
import ModalConfirmView from 'views/modal/modal_confirm';
import ShortTextInputView from 'views/property_editor/short_text_input';

export default RangeView = (function() {
  RangeView = class RangeView extends Marionette.CompositeView {
    static initClass() {

      this.prototype.template = template;
      this.prototype.className = 'ranges-column';
      this.prototype.childViewContainer = '[data-id="range-cells"]';
      this.prototype.childView = ItemView;

      this.prototype.ui = {
        lowRange: '[data-behavior="low"]',
        highRange: '[data-behavior="high"]'
      };

      this.prototype.triggers = {
        'click [data-behavior="destroy"]': 'model:destroy',
        'click [data-behavior="edit"]': 'click:edit',
        'click [data-behavior="move-left"]': 'move:left',
        'click [data-behavior="move-right"]': 'move:right'
      };

      this.prototype.events = {
        'keyup [data-behavior="name"]': 'nameKeyPressed'
      };
    }

    childViewOptions() {
      return {
        rubric: this.rubric,
        range: this.model,
        vent: this.vent
      };
    }

    onModelDestroy() {
      return Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: this.model,
        vent: this,
        descriptionLabel: 'Deleting this range will also delete all descriptions associated with this range.',
        confirmEvent: 'confirm:model:destroy',
        dismissEvent: 'dismiss:model:destroy'
      }));
    }

    onClickEdit() {
      return this.openModal();
    }

    openModal() {
      return Vocat.vent.trigger('modal:open', new ShortTextInputView({
        model: this.model,
        property: 'name',
        saveClasses: 'update-button',
        saveLabel: 'Update Range Name',
        inputLabel: 'What would you like to call this range?',
        vent: this.vent
      }));
    }

    onConfirmModelDestroy() {
      this.ranges.remove(this.model);
      this.model.destroy();
      this.reindex(this.ranges);
      return this.vent.trigger('range:removed');
    }

    reindex(collection) {
      return collection.each((range, index) => range.set('index', index));
    }

    updateLowRange() {
      return this.ui.lowRange.html(this.model.get('low'));
    }

    updateHighRange() {
      return this.ui.highRange.html(this.model.get('high'));
    }

    initialize(options) {
      this.vent = options.vent;
      this.rubric = options.rubric;
      this.collection = options.criteria;
      this.ranges = this.rubric.get('ranges');

      if (this.model != null) {
        this.listenTo(this.model, 'change', function() {
          return this.render();
        });
      }
      return this.listenTo(this.collection, 'all', function() {
        return this.render();
      });
    }
  };
  RangeView.initClass();
  return RangeView;
})();