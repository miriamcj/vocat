/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let RubricLayout;
const template = require('hbs!templates/rubric/rubric_layout');
const RubricModel = require('models/rubric');
const RangeModel = require('models/range');
const RangesView = require('views/rubric/ranges');
const RangePickerModalView = require('views/rubric/range_picker_modal');
const FlashMessagesView = require('views/flash/flash_messages');
const AbstractMatrix = require('views/abstract/abstract_matrix');
const ShortTextInputView = require('views/property_editor/short_text_input');
const LongTextInputView = require('views/property_editor/long_text_input');
const RubricBuilderView = require('views/rubric/rubric_builder');
const ModalConfirmView = require('views/modal/modal_confirm');

export default RubricLayout = (function() {
  RubricLayout = class RubricLayout extends AbstractMatrix {
    static initClass() {

      this.prototype.template = template;
      this.prototype.collections = {};
      this.prototype.views = {};

      this.prototype.regions = {
        fields: '[data-region="criteria"]',
        ranges: '[data-region="ranges"]',
        flash: '[data-region="flash"]',
        rubricBuilder: '[data-region="rubric-builder"]'
      };

      this.prototype.events = {
        'keyup [data-behavior="rubric-name"]': 'handleNameChange',
        'keyup [data-behavior="rubric-desc"]': 'handleDescChange',
        'click [data-region="rubric-public"]': 'handlePublicChange',
        'click [data-trigger="save"]': 'handleSaveClick',
        'click [data-trigger="cancel"]': 'handleCancelClick',
        'click [data-trigger="scoring-modal"]': 'openScoreModal',
        'click [data-trigger="edit-attribute"]': 'editAttributeClick'
      };

      this.prototype.triggers = {
        'click [data-behavior="matrix-slider-left"]': 'slider:left',
        'click [data-behavior="matrix-slider-right"]': 'slider:right',
        'click [data-trigger="recalc"]': 'recalculate:matrix',
        'transitionend [data-region="cells"]': 'transition:end',
        'webkitTransitionEnd [data-region="cells"]': 'transition:end',
        'oTransitionEnd [data-region="cells"]': 'transition:end',
        'otransitionend [data-region="cells"]': 'transition:end',
        'MSTransitionEnd [data-region="cells"]': 'transition:end'
      };

      this.prototype.ui = {
        nameInput: '[data-behavior="rubric-name"]',
        publicInput: '[data-region="rubric-public"]',
        descInput: '[data-behavior="rubric-desc"]',
        lowInput: '[data-behavior="rubric-low"]',
        highInput: '[data-behavior="rubric-high"]',
        rangePointsInput: '[data-behavior="range-points"]',
        sliderLeft: '[data-behavior="matrix-slider-left"]',
        sliderRight: '[data-behavior="matrix-slider-right"]'
      };

      this.prototype.onSliderLeft = _.throttle((function() {
        const cells = this.rubricBuilder.$el.find($('[data-region="cells"]'));
        const unit = 25;
        let currentPosition = this.rubricBuilder.$el.find($('[data-region="cells"]')).position().left/cells.width();
        if (currentPosition < 0) {
          currentPosition = (currentPosition * 100) + unit;
          return cells.css('transform', `translateX(${currentPosition}%)`);
        }
      }), 300);

      this.prototype.onSliderRight = _.throttle((function() {
        if (this.model.get('ranges').length > 4) {
          const cells = this.rubricBuilder.$el.find($('[data-region="cells"]'));
          const unit = 25;
          let currentPosition = cells.position().left/cells.width();
          const maxUnits = -(this.model.get('ranges').length - 4) * (unit/100);
          if (currentPosition > maxUnits) {
            currentPosition = (currentPosition * 100) - unit;
            return cells.css('transform', `translateX(${currentPosition}%)`);
          }
        }
      }), 300);
    }

    editAttributeClick(event) {
      event.preventDefault();
      const attr = $(event.target).data('label');
      const params = {
        model: this.model,
        inputLabel: `Rubric ${attr}`,
        saveLabel: `Update ${attr}`,
        saveClasses: 'update-button',
        property: attr,
        vent: this.vent
      };
      if (attr === 'name') {
        return Vocat.vent.trigger('modal:open', new ShortTextInputView(params));
      } else if (attr === 'description') {
        return Vocat.vent.trigger('modal:open', new LongTextInputView(params));
      }
    }

    displayLeftSlider() {
      const currentPosition = this.rubricBuilder.$el.find($('[data-region="cells"]')).position();
      if (currentPosition.left < 0) {
        return $('[data-behavior="matrix-slider-left"]').css('visibility', 'visible');
      } else {
        return $('[data-behavior="matrix-slider-left"]').css('visibility', 'hidden');
      }
    }

    displayRightSlider() {
      const cells = this.rubricBuilder.$el.find($('[data-region="cells"]'));
      const unit = 25;
      const currentPosition = cells.position().left/cells.width();
      const maxUnits = -(this.model.get('ranges').length - 4) * (unit/100);
      if (currentPosition > maxUnits) {
        return $('[data-behavior="matrix-slider-right"]').css('visibility', 'visible');
      } else {
        return $('[data-behavior="matrix-slider-right"]').css('visibility', 'hidden');
      }
    }

    displaySliders() {
      if (this.model.get('ranges').length <= 4) {
        this.rubricBuilder.$el.find($('[data-region="cells"]')).css('transform', 'translateX(0)');
        $('[data-behavior="matrix-slider-left"]').css('visibility', 'hidden');
        $('[data-behavior="matrix-slider-right"]').css('visibility', 'hidden');
      } else {
        this.displayLeftSlider();
        this.displayRightSlider();
      }
      return this.trigger('sliders:displayed');
    }

    onTransitionEnd() {
      return this.displaySliders();
    }

    repositionRubric(oldPosition) {
      const cells = this.rubricBuilder.$el.find($('[data-region="cells"]'));
      if (this.model.get('ranges').length > 4) {
        return cells.css('transform', `translateX(${oldPosition.left}px)`);
      }
    }

    openScoreModal() {
      const rangePickerModal = new RangePickerModalView({collection: this.model.get('ranges'), model: this.model, vent: this});
      return Vocat.vent.trigger('modal:open', rangePickerModal);
    }

    handlePublicChange(event) {
      event.stopPropagation();
      event.preventDefault();
      this.ui.publicInput.toggleClass('switch-checked');
      if (this.ui.publicInput.hasClass('switch-checked')) {
        return this.model.set('public', true);
      } else {
        return this.model.set('public', false);
      }
    }

    onHandleLowChange(low) {
      if (this.model.isValidLow(low)) {
        return this.model.setLow(low);
      } else {
        this.ui.lowInput.val(this.model.getLow());
        return this.trigger('error:add', {
          level: 'notice',
          msg: `Setting the lowest possible score above ${this.model.getLow()} would make the total range too small to accomodate this rubric. Before you can increase the lowest possible score, you must remove one or more ranges from your rubric.`
        });
      }
    }

    onHandleHighChange(high) {
      if (this.model.isValidHigh(high)) {
        return this.model.setHigh(high);
      } else {
        this.ui.highInput.val(this.model.getHigh());
        return this.trigger('error:add', {
          level: 'notice',
          msg: `Setting the highest possible score below ${this.model.getHigh()} would make the total range too small to accomodate this rubric. Before you can reduce the highest possible score, you must remove one or more ranges from your rubric.`
        });
      }
    }

    handleNameChange(event) {
      return this.model.set('name', this.ui.nameInput.val());
    }

    handleDescChange(event) {
      return this.model.set('description', this.ui.descInput.val());
    }

    handleSaveClick(event) {
      event.preventDefault();
      return this.model.save({}, {
        success: () => {
          this.changed = false;
          return Vocat.vent.trigger('error:add', {level: 'notice', msg: 'Rubric has been saved'});
        }
        , error: (model, xhr) => {
          let msg;
          if (xhr.responseJSON != null) {
            msg = xhr.responseJSON;
          } else {
            msg = 'Unable to save rubric. Be sure to add a title, and at least one range and field.';
          }
          return Vocat.vent.trigger('error:add', {level: 'error', msg});
        }
      });
    }

    handleCancelClick(event) {
      event.preventDefault();
      if (this.changed) {
        return Vocat.vent.trigger('modal:open', new ModalConfirmView({
          model: this.model,
          vent: this,
          headerLabel: "Are You Sure?",
          descriptionLabel: "If you proceed, you will lose all unsaved changes.",
          confirmEvent: 'confirm:cancel',
          dismissEvent: 'dismiss:cancel'
        }));
      } else {
        return this.trigger('confirm:cancel');
      }
    }

    onCancel() {
      return window.location = '/admin/rubrics';
    }

    onRangeRemoved() {
      if (this.model.get('ranges').length > 4) {
        const cells = this.rubricBuilder.$el.find($('[data-region="cells"]'));
        const unit = 25;
        let currentPosition = cells.position().left/cells.width();
        const maxUnits = -(this.model.get('ranges').length - 4) * (unit/100);
        if (currentPosition < maxUnits) {
          currentPosition = (currentPosition * 100) + unit;
          return cells.css('transform', `translateX(${currentPosition}%)`);
        }
      }
    }

    parseRangePoints(rangePoints) {
      if (rangePoints == null) { rangePoints = ''; }
      let numbers = rangePoints.split(' ');
      numbers = _.map(numbers, function(num) {
        const n = parseInt(num);
        if (!_.isNaN(n)) {
          return n;
        }
      });
      numbers = _.reject(numbers, num => num == null);
      numbers = _.uniq(numbers).sort((a, b) => a - b);
      return numbers;
    }

    serializeData() {
      const results = super.serializeData();
      results.current_user_is_admin = ((window.VocatUserRole === 'administrator') || (window.VocatUserRole === 'superadministrator'));
      results.new_record = this.new_record;
      return results;
    }

    initialize(options) {
      if (!this.model) {
        if (options.rubricId) {
          this.model = new RubricModel({id: options.rubricId});
          this.model.fetch({
            success: model => {
              return this.render();
            }
          });
          this.new_record = false;
        } else {
          this.model = new RubricModel({});
          this.new_record = true;
        }
      }

      this.listenTo(this.model, 'change', e => {
        this.recalculateMatrix();
        this.displaySliders();
        return this.changed = true;
      });

      this.listenTo(this.model, 'change:name change:description', () => {
        if (!this.new_record) { return this.render(); }
      });

      this.listenTo(this.model, 'invalid', (model, errors) => {
        return this.trigger('error:add', {level: 'error', lifetime: 5000, msg: errors});
      });

      this.listenTo(this, 'range:move:left range:move:right', function(event) {
        this.repositionRubric(event.currentPosition);
        return this.displaySliders();
      });
      this.listenTo(this, 'range:removed', function() {
        return this.onRangeRemoved();
      });
      return this.listenTo(this, 'confirm:cancel', function() {
        return this.onCancel();
      });
    }

    onShow() {
      return this.parentOnShow();
    }

    onRender() {
      this.rubricBuilder.show(new RubricBuilderView({model: this.model, vent: this}));
      this.displaySliders();
      return this.flash.show(new FlashMessagesView({vent: this, clearOnAdd: true}));
    }
  };
  RubricLayout.initClass();
  return RubricLayout;
})();
