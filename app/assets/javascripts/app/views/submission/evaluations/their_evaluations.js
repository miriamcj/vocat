/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import { uniq } from "lodash";
import template from 'templates/submission/evaluations/their_evaluations.hbs';
import TheirEvaluationsCollection from 'views/submission/evaluations/their_evaluations_collection';
import CollectionProxy from 'collections/collection_proxy';
import EvaluationSetModel from 'models/evaluation_set';

export default class TheirEvaluations extends Marionette.CompositeView {
  constructor() {

    this.template = template;
    this.tagName = 'ul';
    this.className = 'evaluation-collections';
    this.childView = TheirEvaluationsCollection;
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
    const evalTypes = uniq(this.evaluations.pluck('evaluator_role'));
    return evalTypes.forEach((evalRole, index) => {
      const proxy = new CollectionProxy(this.evaluations);

      proxy.where(model => (model.get('evaluator_role') === evalRole) && (model.get('current_user_is_evaluator') !== true));
      if (proxy.length > 0) {
        const set = new EvaluationSetModel({evaluations: proxy, evaluator_role: evalRole});
        return this.collection.add(set);
      }
    });
  }
}

