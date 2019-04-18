/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import template from 'hbs!templates/submission/evaluations/their_evaluations_child';
import ExpandableRange from 'behaviors/expandable_range';

export default TheirEvaluationsChild = (function() {
  TheirEvaluationsChild = class TheirEvaluationsChild extends Marionette.ItemView {
    static initClass() {

      this.prototype.tagName = 'li';
      this.prototype.className = 'evaluation-single';
      this.prototype.template = template;
      this.prototype.childrenVisible = false;

      this.prototype.triggers = {
      };

      this.prototype.events = {
        'mouseenter @ui.placardTrigger': 'showPlacard',
        'mouseleave @ui.placardTrigger': 'hidePlacard'
      };

      this.prototype.ui = {
        'placard': '[data-behavior="range-placard"]',
        'placardTrigger': '[data-behavior="placard-trigger"]'
      };

      this.prototype.behaviors = {
        expandableRange: {
          behaviorClass: ExpandableRange
        }
      };
    }

    showPlacard(e) {
      e.preventDefault();
      e.stopPropagation();
      const $el = $(e.target);
      return $el.find('[data-behavior="range-placard"]').fadeIn();
    }

    hidePlacard(e) {
      e.preventDefault();
      e.stopPropagation();
      return this.ui.placard.hide();
    }

    setupEvents() {
      return this.listenTo(this, 'show:placard', e => {
        return this.onShowPlacard(e);
      });
    }

    initialize(options) {
      this.rubric = options.rubric;
      return this.setupEvents();
    }

    serializeData() {
      const sd ={
        title: this.model.get('evaluator_name'),
        percentage: Math.round(this.model.get('total_percentage')),
        score_details: this.model.scoreDetailsWithRubricDescriptions(this.rubric),
        points_possible: this.model.get('points_possible'),
        total_score: this.model.get('total_score')
      };
      return sd;
    }
  };
  TheirEvaluationsChild.initClass();
  return TheirEvaluationsChild;
})();
