/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import template from 'templates/submission/evaluations/their_evaluations_child.hbs';
import ExpandableRange from 'behaviors/expandable_range';

export default class TheirEvaluationsChild extends Marionette.ItemView {
  constructor() {

    this.tagName = 'li';
    this.className = 'evaluation-single';
    this.template = template;
    this.childrenVisible = false;

    this.triggers = {
    };

    this.events = {
      'mouseenter @ui.placardTrigger': 'showPlacard',
      'mouseleave @ui.placardTrigger': 'hidePlacard'
    };

    this.ui = {
      'placard': '[data-behavior="range-placard"]',
      'placardTrigger': '[data-behavior="placard-trigger"]'
    };

    this.behaviors = {
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
}
