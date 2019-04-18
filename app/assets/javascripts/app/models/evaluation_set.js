/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

let EvaluationSetModel;

export default EvaluationSetModel = class EvaluationSetModel extends Backbone.Model {

  averageScore() {
    const numbers = this.get('evaluations').pluck('total_percentage');
    return Math.round(_.reduce(numbers, (memo, num) => memo + num
    , 0) / numbers.length);
  }

  toJSON() {
    const attributes = _.clone(this.attributes);
    attributes.averageScore = this.averageScore();
    return attributes;
  }
};
