/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/rubric/range.hbs';
import ItemView from 'views/rubric/ranges_item';
import ModalConfirmView from 'views/modal/modal_confirm';
import ShortTextInputView from 'views/property_editor/short_text_input';

export default class RangeView extends Marionette.CompositeView.extend({
  template: template,
  className: 'ranges-column',
  childViewContainer: '[data-id="range-cells"]',
  childView: ItemView,

  ui: {
    lowRange: '[data-behavior="low"]',
    highRange: '[data-behavior="high"]'
  },

  triggers: {
    'click [data-behavior="destroy"]': 'model:destroy',
    'click [data-behavior="edit"]': 'click:edit',
    'click [data-behavior="move-left"]': 'move:left',
    'click [data-behavior="move-right"]': 'move:right'
  },

  events: {
    'keyup [data-behavior="name"]': 'nameKeyPressed'
  }
}) {
  childViewOptions() {
    return {
      rubric: this.rubric,
      range: this.model,
      vent: this.vent
    };
  }

  onModelDestroy() {
    return window.Vocat.vent.trigger('modal:open', new ModalConfirmView({
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
    return window.Vocat.vent.trigger('modal:open', new ShortTextInputView({
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