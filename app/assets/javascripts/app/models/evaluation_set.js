/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

import { clone } from "lodash";

export default class EvaluationSetModel extends Backbone.Model {

  averageScore() {
    const numbers = this.get('evaluations').pluck('total_percentage');
    return Math.round(numbers.reduce((memo, num) => memo + num, 0) / numbers.length);
  }

  toJSON() {
    const attributes = clone(this.attributes);
    attributes.averageScore = this.averageScore();
    return attributes;
  }
}
