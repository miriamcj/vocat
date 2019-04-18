/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let Criteria;
  const template = require('hbs!templates/rubric/criteria');
  const ItemView = require('views/rubric/criteria_item');


  return Criteria = (function() {
    Criteria = class Criteria extends Marionette.CompositeView {
      static initClass() {
  
        this.prototype.template = template;
        this.prototype.className = 'criteria';
        this.prototype.childViewContainer = '[data-region="criteria-rows"]';
        this.prototype.childView = ItemView;
  
        this.prototype.ui = {
          criteriaAdd: '.criteria-add-button',
          criteriaInstruction: '.criteria-instruction'
        };
      }

      childViewOptions() {
        return {
          collection: this.collection
        };
      }

      showCriteriaAdd() {
        if (this.collection.length > 3) {
          return $(this.ui.criteriaAdd).css('display', 'none');
        } else {
          return $(this.ui.criteriaAdd).css('display', 'inline-block');
        }
      }

      showCriteriaInstruction() {
        if (this.collection.length > 0) {
          return $(this.ui.criteriaInstruction).css('display', 'none');
        } else {
          return $(this.ui.criteriaInstruction).css('display', 'inline-block');
        }
      }

      onShow() {
        this.showCriteriaAdd();
        return this.showCriteriaInstruction();
      }

      initialize(options) {
        return this.listenTo(this, 'add:child destroy:child remove:child', function() {
          this.showCriteriaAdd();
          return this.showCriteriaInstruction();
        });
      }
    };
    Criteria.initClass();
    return Criteria;
  })();
});