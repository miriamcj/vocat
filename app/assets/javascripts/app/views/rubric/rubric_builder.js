/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import template from 'templates/rubric/rubric_builder.hbs';
import { $ } from "jquery";
import CriteriaView from 'views/rubric/criteria';
import RangesView from 'views/rubric/ranges';
import RangeModel from 'models/range';
import FieldModel from 'models/field';
import RubricModel from 'models/rubric';
import ShortTextInputView from 'views/property_editor/short_text_input';
ShortTextInputView = require('views/property_editor/short_text_input');


export default class RubricBuilder extends Marionette.LayoutView {
  constructor() {

    this.template = template;
    this.collections = {};

    this.regions = {
      criteria: '[data-region="criteria"]',
      bodyWrapper: '[data-region="body-wrapper"]',
      addButtons: '[data-region="add-buttons"]'
    };

    this.events = {
      'click [data-trigger="rangeAdd"]': 'handleRangeAdd',
      'click [data-trigger="criteriaAdd"]': 'handleCriteriaAdd'
    };

    this.ui = {
      rangeSnap: '.range-add-snap',
      criteriaSnap: '.criteria-add-snap',
      cells: '[data-region="cells"]'
    };
  }

  newRange() {
    const range = new RangeModel({index: this.collections.ranges.length});
    const modal = new ShortTextInputView({
      model: range,
      property: 'name',
      saveClasses: 'update-button',
      saveLabel: 'Add Range',
      inputLabel: 'What would you like to call this range?',
      vent: this.vent
    });
    this.listenTo(modal, 'model:updated', function(e) {
      return this.model.get('ranges').add(range);
    });
    return Vocat.vent.trigger('modal:open', modal);
  }

  handleRangeAdd(event) {
    event.preventDefault();
    if (this.model.availableRanges()) {
      return this.newRange();
    } else if (this.model.getHigh() < 100) {
      this.model.setHigh(this.model.getHigh() + 1);
      return this.newRange();
    } else {
      return this.trigger('error:add', {
        level: 'notice',
        msg: 'Before you can add another range to this rubric, you must increase the number of available points by changing the highest possible score field, above.'
      });
    }
  }

  handleCriteriaAdd(event) {
    event.preventDefault();
    const field = new FieldModel({index: this.collections.criteria.length});
    const modal = new ShortTextInputView({
      model: field,
      property: 'name',
      saveClasses: 'update-button',
      saveLabel: 'Add Criteria',
      inputLabel: 'What would you like to call this criteria?',
      vent: this.vent
    });
    this.listenTo(modal, 'model:updated', function(e) {
      return this.model.get('fields').add(field);
    });
    return Vocat.vent.trigger('modal:open', modal);
  }

  showCriteriaSnap() {
    if (this.collections.criteria.length > 3) {
      $(this.ui.criteriaSnap).css('display', 'inline-block');
      return $('.criteria-bar').css('visibility', 'hidden');
    } else {
      $(this.ui.criteriaSnap).css('display', 'none');
      return $('.criteria-bar').css('visibility', 'visible');
    }
  }

  showRangeSnap() {
    if (this.collections.ranges.length <= 3) {
      $(this.ui.rangeSnap).css('display', 'none');
      return $('.range-bar').css('visibility', 'visible');
    } else if (this.collections.ranges.length === 4) {
      $('.range-bar').css('visibility', 'hidden');
      return $(this.ui.rangeSnap).css({'display': 'inline-block', 'width': '116px'});
    } else if ($('.cells').position().left === (-(this.model.get('ranges').length - 4) * 218)) {
      $('.range-bar').css('visibility', 'hidden');
      return $(this.ui.rangeSnap).css({'display': 'inline-block', 'width': '116px', 'z-index': '10'});
    } else {
      $('.range-bar').css('visibility', 'hidden');
      return $(this.ui.rangeSnap).css({'display': 'inline-block', 'width': '55px'});
    }
  }

  initialize(options) {
    this.vent = options.vent;
    this.collections.ranges = this.model.get('ranges');
    this.collections.criteria = this.model.get('fields');
    this.showCriteriaSnap();
    this.listenTo(this.collections.criteria, 'add remove', function(event) {
      return this.showCriteriaSnap();
    });

    this.listenTo(this.collections.ranges, 'add remove', function(event) {
      return this.showRangeSnap();
    });

    return this.listenTo(this.vent, 'sliders:displayed', function(event) {
      return this.showRangeSnap();
    });
  }

  onRender() {
    this.criteria.show(new CriteriaView({collection: this.collections.criteria, vent: this.vent}));
    return this.bodyWrapper.show(new RangesView({collection: this.collections.ranges, rubric: this.model, criteria: this.collections.criteria, vent: this.vent}));
  }

  onShow() {
    this.showCriteriaSnap();
    return this.showRangeSnap();
  }
}