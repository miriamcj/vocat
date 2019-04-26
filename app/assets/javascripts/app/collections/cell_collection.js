/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import CellModel from 'models/cell';

export default class CellCollection extends Backbone.Collection.extend({
  model: CellModel
}) {
  comparator(range) {
    return range.get('low');
  }
};