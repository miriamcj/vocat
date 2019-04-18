/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import AbstractModel from 'models/abstract_model';
import { toArray, clone, size } from "lodash";
import FieldCollection from 'collections/field_collection';
import RangeCollection from 'collections/range_collection';
import CellCollection from 'collections/cell_collection';
import RangeModel from 'models/range';
import FieldModel from 'models/field';
import CellModel from 'models/cell';

export default class Rubric extends AbstractModel {
  constructor() {

    this.courseId = null;

    this.defaults = {
      low: 0,
      high: 1
    };
  }

  urlRoot() {
    return '/api/v1/rubrics';
  }

  initialize(options) {
    this.set('fields', new FieldCollection(toArray(this.get('fields'))));
    this.set('ranges', new RangeCollection(toArray(this.get('ranges'))));
    this.set('cells', new CellCollection(toArray(this.get('cells')), {}));

    this.listenTo(this.get('fields'), 'add remove', function(e) {
      return this.trigger('change');
    });

    this.listenTo(this.get('ranges'), 'add remove', function(e) {
      return this.trigger('change');
    });

    this.get('fields').bind('add', field => {
      return this.get('ranges').each(range => {
        const cell = new CellModel({range: range.id, field: field.id});
        cell.fieldModel = field;
        cell.rangeModel = range;
        return this.get('cells').add(cell);
      });
    });

    this.get('fields').bind('remove', field => {
      return this.get('cells').remove(this.get('cells').where({field: field.id}));
    });

    this.get('ranges').bind('add', range => {
      return this.get('fields').each(field => {
        const cell = new CellModel({range: range.id, field: field.id});
        cell.fieldModel = field;
        cell.rangeModel = range;
        return this.get('cells').add(cell);
      });
    });

    return this.get('ranges').bind('remove', range => {
      return this.get('cells').remove(this.get('cells').where({range: range.id}));
    });
  }


  getFieldNameById(fieldId) {
    const field = this.get('fields').findWhere({id: fieldId});
    if (field != null) { return field.get('name'); }
  }

  getRangeString() {
    const values = this.getLows();
    values.push(this.getHigh());
    return values.join(' ');
  }

  availableRanges() {
    const maxRanges = (this.get('high') - this.get('low')) + 1;
    const rangeCount = this.get('ranges').length;
    return (rangeCount + 1) <= maxRanges;
  }

  getLows() {
    let lows;
    const ranges = this.get('ranges');
    if (ranges.length > 0) { lows = ranges.pluck('low'); }
    return lows;
  }

  getHigh() {
    return this.get('high');
  }

  getLow() {
    return this.get('low');
  }

  getLows() {
    return this.get('ranges').pluck('low');
  }

  isValidLow(low) {
    const difference = this.getHigh() - parseInt(low);
    const out = difference >= (this.get('ranges').length - 1);
    return out;
  }

  isValidHigh(high) {
    const difference = parseInt(high) - this.getLow();
    return difference >= (this.get('ranges').length - 1);
  }

  setLow(value) {
    return this.set('low', parseInt(value));
  }

  setHigh(value) {
    return this.set('high', parseInt(value));
  }

  getRangeForScore(score) {
    return this.get('ranges').find(function(range) {
      const s = parseInt(score);
      return (s >= range.get('low')) && (s <= range.get('high'));
    });
  }

  getDescriptionByFieldAndScore(fieldId, score) {
    const range = this.getRangeForScore(score);
    const desc = this.getCellDescription(fieldId, range.id);
    return desc;
  }

  getCellDescription(fieldId, rangeId) {
    const cell = this.get('cells').findWhere({field: fieldId, range: rangeId});
    if (cell != null) { return cell.get('description'); }
  }

  parse(response, options) {
    if (response != null) {
      if (!this.get('fields')) { this.set('fields', new FieldCollection); }
      if (!this.get('ranges')) { this.set('ranges', new RangeCollection); }
      if (!this.get('cells')) { this.set('cells', new CellCollection); }

      response.ranges.forEach((range, index) => {
        range.index = index;
        range = new RangeModel(range);
        return this.get('ranges').add(range, {silent: true});
      });

      response.fields.forEach((field, index) => {
        field.index = index;
        field = new FieldModel(field);
        return this.get('fields').add(field, {silent: true});
      });

      response.cells.forEach(cell => {
        cell = new CellModel(cell);
        cell.fieldModel = this.get('fields').get(cell.get('field'));
        cell.rangeModel = this.get('ranges').get(cell.get('range'));
        return this.get('cells').add(cell, {silent: true});
      });

      delete response['ranges'];
      delete response['fields'];
      delete response['cells'];
    }
    return response;
  }

  toJSON() {
    const attributes = clone(this.attributes);
    return $.each(attributes, function(key, value) {
      if ((value != null) && _(value.toJSON).isFunction()) {
        return attributes[key] = value.toJSON();
      }
    });
  }


  validateName(attrs, options) {
    if (!attrs.name || (attrs.name.length < 1)) {
      this.addError(this.errors, 'name', 'cannot be empty');
      return false;
    } else {
      return true;
    }
  }

  validate(attrs, options) {
    this.errors = {};
    this.validateName(attrs, options);
    if (size(this.errors) > 0) { return this.errors; } else { return false; }
  }
}
