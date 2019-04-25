/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import RowModel from 'models/row';

export default class RowCollection extends Backbone.Collection.extend({
  model: RowModel
}) {};
