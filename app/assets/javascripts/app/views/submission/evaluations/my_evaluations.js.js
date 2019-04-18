/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let MyEvaluations;
  const Marionette = require('marionette');
  const template = require('hbs!templates/submission/evaluations/my_evaluations');
  const ScoreSlider = require('views/submission/evaluations/score_slider');
  const ExpandableRange = require('behaviors/expandable_range');
  const ScoreCollection = require('collections/score_collection');
  const ModalConfirmView = require('views/modal/modal_confirm');

  return MyEvaluations = (function() {
    MyEvaluations = class MyEvaluations extends Marionette.CompositeView {
      static initClass() {
  
        this.prototype.tagName = 'ul';
        this.prototype.template = template;
        this.prototype.className = 'evaluation-collections evaluation-editable';
        this.prototype.childView = ScoreSlider;
  
        this.prototype.ui = {
          utility: '[data-behavior="utility"]',
          subtotal: '[data-behavior="subtotal"]',
          total: '[data-behavior="total"]',
          destroyButton: '[data-behavior="evaluation-destroy"]',
          saveButton: '[data-behavior="evaluation-save"]',
          percentage: '[data-container="percentage"]',
          totalScore: '[data-container="total-score"]',
          subtotalScore: '[data-container="subtotal-score"]',
          childInsertBefore: '[data-anchor="child-insert-before"]',
          publishCheckbox: '[data-behavior="publish-switch"]',
          rangeFill: '[data-behavior="range-fill"]',
          publishSwitch: '.switch',
          notice: '[data-behavior="notice"]'
        };
  
        this.prototype.behaviors = {
          expandableRange: {
            behaviorClass: ExpandableRange
          }
        };
  
        this.prototype.triggers = {
          'click @ui.destroyButton': 'evaluation:destroy',
          'click @ui.saveButton': 'evaluation:save',
          'click [data-behavior="toggle-detail"]': 'detail:toggle',
          'click @ui.publishCheckbox': {
            event: 'evaluation:toggle',
            preventDefault: false
          }
  
        };
      }

      childViewOptions() {
        return {
        vent: this,
        rubric: this.rubric
        };
      }

      onEvaluationDestroy() {
        return Vocat.vent.trigger('modal:open', new ModalConfirmView({
          model: this.model,
          vent: this,
          descriptionLabel: 'Deleted evaluations cannot be recovered.',
          confirmEvent: 'confirm:destroy',
          dismissEvent: 'dismiss:destroy'
        }));
      }

      onEvaluationSave() {
        return this.vent.triggerMethod('evaluation:save');
      }

      onConfirmDestroy() {
        return this.vent.triggerMethod('evaluation:destroy');
      }

      onEvaluationToggle() {
        const state = this.model.get('published');
        if (state === true) {
          this.model.set('published', false);
        } else {
          this.model.set('published', true);
        }
        this.vent.triggerMethod('evaluation:dirty');
        return this.updatePublishedUIState();
      }

      updatePublishedUIState() {
        if (this.model.get('published') === true) {
          this.ui.publishSwitch.addClass('switch-checked');
          return this.ui.publishCheckbox.attr('checked', true);
        } else {
          this.ui.publishSwitch.removeClass('switch-checked');
          return this.ui.publishCheckbox.attr('checked', false);
        }
      }

      updateCollectionFromModel() {
        if (this.model != null) {
          return this.collection = this.model.getScoresCollection();
        } else {
          return this.collection = new ScoreCollection();
        }
      }

      showSaveSuccessNotice() {
        this.ui.notice.html('Your evaluation has been successfully saved.');
        this.ui.notice.fadeIn();
        return setTimeout(() => {
          if ((this.ui.notice.length > 0) && _.isFunction(this.ui.notice.slideUp)) {
            return this.ui.notice.slideUp();
          }
        }
        , 5000);
      }

      setupListeners() {
        this.listenTo(this, 'childview:updated', () => {
          this.vent.triggerMethod('evaluation:dirty');
          return this.updateTotals();
        });
        this.listenTo(this.model, 'change', () => {
          return this.updatePublishedUIState();
        });
        return this.listenTo(this.vent, 'evaluation:save:success', () => {
          return this.showSaveSuccessNotice();
        });
      }

      initialize(options) {
        this.vent = options.vent;
        this.rubric = options.rubric;
        this.setupListeners();
        return this.updateCollectionFromModel();
      }

      updateTotals() {
        this.ui.percentage.html(this.model.get('total_percentage_rounded'));
        this.ui.rangeFill.animate({width: `${this.model.get('total_percentage_rounded')}%`});
        this.ui.totalScore.html(this.model.get('total_score'));
        return this.ui.subtotalScore.html(this.model.get('total_score'));
      }

      attachHtml(collectionView, childView, index) {
        if (collectionView.isBuffering) {
          return collectionView.elBuffer.appendChild(childView.el);
        } else {
          return $(childView.el).insertBefore(collectionView.ui.childInsertBefore);
        }
      }

      attachBuffer(collectionView, buffer) {
        return $(buffer).insertBefore(collectionView.ui.childInsertBefore);
      }

      onRender() {
        return this.updatePublishedUIState();
      }
    };
    MyEvaluations.initClass();
    return MyEvaluations;
  })();
});