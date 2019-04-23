/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import FieldModel from 'models/field';

export default class FieldCollection extends Backbone.Collection {
  constructor() {
    this.model = FieldModel;
  }
};

