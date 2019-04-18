/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let TheirEvaluations;
const Marionette = require('marionette');
const template = require('hbs!templates/submission/evaluations/their_evaluations');
const TheirEvaluationsCollection = require('views/submission/evaluations/their_evaluations_collection');
const CollectionProxy = require('collections/collection_proxy');
const EvaluationSetModel = require('models/evaluation_set');

export default TheirEvaluations = (function() {
  TheirEvaluations = class TheirEvaluations extends Marionette.CompositeView {
    static initClass() {

      this.prototype.template = template;
      this.prototype.tagName = 'ul';
      this.prototype.className = 'evaluation-collections';
      this.prototype.childView = TheirEvaluationsCollection;
    }
    childViewOptions() {
      return {
      rubric: this.rubric
      };
    }

    initialize(options) {
      this.evaluations = Marionette.getOption(this, 'evaluations');
      this.rubric = options.rubric;

      this.collection = new Backbone.Collection;
      const evalTypes = _.uniq(this.evaluations.pluck('evaluator_role'));
      return _.each(evalTypes, (evalRole, index) => {
        const proxy = new CollectionProxy(this.evaluations);

        proxy.where(model => (model.get('evaluator_role') === evalRole) && (model.get('current_user_is_evaluator') !== true));
        if (proxy.length > 0) {
          const set = new EvaluationSetModel({evaluations: proxy, evaluator_role: evalRole});
          return this.collection.add(set);
        }
      });
    }
  };
  TheirEvaluations.initClass();
  return TheirEvaluations;
})();

