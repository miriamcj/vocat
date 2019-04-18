/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let EvaluationsLayout;
  const Marionette = require('marionette');
  const template = require('hbs!templates/submission/evaluations/evaluations_layout');
  const EvaluationCollection = require('collections/evaluation_collection');
  const Evaluation = require('models/evaluation');
  const CollectionProxy = require('collections/collection_proxy');
  const TheirEvaluations = require('views/submission/evaluations/their_evaluations');
  const TheirEvaluationsEmpty = require('views/submission/evaluations/their_evaluations_empty');
  const MyEvaluations = require('views/submission/evaluations/my_evaluations');
  const MyEvaluationsCreate = require('views/submission/evaluations/my_evaluations_create');
  const SaveNotifyView = require('views/submission/evaluations/save_notify');
  const RubricModel = require('models/rubric');

  return EvaluationsLayout = (function() {
    EvaluationsLayout = class EvaluationsLayout extends Marionette.LayoutView {
      static initClass() {
  
        this.prototype.template = template;
  
        this.prototype.regions = {
          theirEvaluations: '[data-region="their-evaluations"]',
          myEvaluations: '[data-region="my-evaluations"]'
        };
  
        this.prototype.ui = {
          body: '[data-behavior="body"]'
        };
      }

      onEvaluationDestroy() {
        const myEvaluation = this.evaluations.findWhere({current_user_is_evaluator: true});
        return myEvaluation.destroy({
          wait: true, success: () => {
            this.showMyEvaluations();
            return Vocat.vent.trigger('notification:empty');
          }
        });
      }

      onEvaluationDirty() {
        const saveNotifyView = new SaveNotifyView({model: this.myEvaluationModel(), vent: this});
        return Vocat.vent.trigger('notification:show', saveNotifyView);
      }

      onEvaluationSave() {
        const m = this.myEvaluationModel();
        if (m != null) {
          Vocat.vent.trigger('notification:empty');
          m.save({}, {
            success: response => {
              return this.trigger('evaluation:save:success');
            },
  //            @model.fetch()
            error: response => {
              return Vocat.vent.trigger('error:add', {level: 'error', msg: 'Unable to save evaluation'});
            }
          });
          if (m.validationError) {
            return Vocat.vent.trigger('error:add', {level: 'error', msg: m.validationError});
          }
        }
      }

      onEvaluationRevert() {
        const m = this.myEvaluationModel();
        if (m != null) {
          return m.revert();
        }
      }

      // This generally is triggered by the child empty view
      onEvaluationNew() {
        const evaluation = new Evaluation({submission_id: this.model.id});
        return evaluation.save({}, {
          success: () => {
            this.evaluations.add(evaluation);
            this.vent.triggerMethod('evaluation:created');
            this.model.unsetMyEvaluation();
            return this.showMyEvaluations(true);
          }
          , error: () => {
            Vocat.vent.trigger('error:add', {
              level: 'error',
              msg: 'Unable to create evaluation. Perhaps you do not have permission to evaluate this submission.'
            });
            return this.showMyEvaluations();
          }
        });
      }

      // @model is a submission model.
      initialize(options) {
        this.vent = Marionette.getOption(this, 'vent');
        this.courseId = Marionette.getOption(this, 'courseId');
        this.rubric = new RubricModel(this.model.get('project').rubric);

        return this.evaluations = new EvaluationCollection(this.model.get('evaluations'), {courseId: this.courseId});
      }

      myEvaluationModel() {
        return this.evaluations.findWhere({current_user_is_evaluator: true});
      }

      showMyEvaluations(openOnShow) {
        if (openOnShow == null) { openOnShow = false; }
        if (this.myEvaluationModel() != null) {
          this.myEvaluations.show(new MyEvaluations({model: this.myEvaluationModel(), rubric: this.rubric, vent: this}));
          if (openOnShow === true) {
            return this.myEvaluations.currentView.triggerMethod('toggle:child');
          }
        } else {
          return this.myEvaluations.show(new MyEvaluationsCreate({evaluations: this.evaluations, rubric: this.rubric, vent: this}));
        }
      }

      showTheirEvaluations() {
        if ((this.myEvaluationModel() && (this.evaluations.length === 1)) || (this.evaluations.length === 0)) {
          this.theirEvaluations.$el.addClass('evaluation-collection-empty');
          if (this.model.get('abilities').can_evaluate === false) {
            return this.theirEvaluations.show(new TheirEvaluationsEmpty());
          }
        } else {
          this.theirEvaluations.$el.removeClass('evaluation-collection-empty');
          return this.theirEvaluations.show(new TheirEvaluations({evaluations: this.evaluations, rubric: this.rubric}));
        }
      }

      onRender() {
        this.showTheirEvaluations();
        if (this.model.get('abilities').can_evaluate === true) {
          return this.showMyEvaluations();
        }
      }
    };
    EvaluationsLayout.initClass();
    return EvaluationsLayout;
  })();
});