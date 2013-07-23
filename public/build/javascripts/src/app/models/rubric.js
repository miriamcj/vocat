(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'collections/field_collection', 'collections/range_collection'], function(Backbone, FieldCollection, RangeCollection) {
    var Rubric, _ref;

    return Rubric = (function(_super) {
      __extends(Rubric, _super);

      function Rubric() {
        _ref = Rubric.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Rubric.prototype.courseId = null;

      Rubric.prototype.urlRoot = function() {
        if (this.courseId != null) {
          return "/courses/" + this.courseId + "/rubrics";
        } else {
          return '/rubrics';
        }
      };

      Rubric.prototype.initialize = function(options) {
        var _this = this;

        this.set('fields', new FieldCollection(_.toArray(this.get('fields'))));
        this.set('ranges', new RangeCollection(_.toArray(this.get('ranges'))));
        this.get('fields').bind('add remove change', function() {
          _this.prevalidate();
          return _this.trigger('change');
        });
        return this.get('ranges').bind('add remove change', function() {
          _this.ranges().sort();
          _this.prevalidate();
          return _this.trigger('change');
        });
      };

      Rubric.prototype.ranges = function() {
        return this.get('ranges');
      };

      Rubric.prototype.fields = function() {
        return this.get('fields');
      };

      Rubric.prototype.setDescriptionByName = function(fieldName, rangeName, description) {
        var field, range;

        field = this.get('fields').where({
          name: fieldName
        })[0];
        range = this.get('ranges').where({
          name: rangeName
        })[0];
        return this.setDescription(field, range, description);
      };

      Rubric.prototype.setDescription = function(field, range, description) {
        return field.setDescription(range, description);
      };

      Rubric.prototype.addField = function(value) {
        var field;

        if (_.isObject(value)) {
          field = value;
        } else {
          field = {
            'name': value,
            description: 'Enter a description...'
          };
        }
        return this.fields().add(field);
      };

      Rubric.prototype.removeField = function(id) {
        return this.fields().remove(this.fields().get(id));
      };

      Rubric.prototype.addRange = function(value) {
        var range;

        if (_.isObject(value)) {
          range = value;
        } else {
          range = {
            'name': value,
            low: this.nextRangeLowValue(),
            high: this.nextRangeHighValue()
          };
        }
        return this.ranges().add(range);
      };

      Rubric.prototype.removeRange = function(id) {
        return this.ranges().remove(this.ranges().get(id));
      };

      Rubric.prototype.highestHigh = function() {
        if (this.ranges().length > 0) {
          return this.ranges().max(function(range) {
            return range.get('high');
          }).get('high');
        } else {
          return 0;
        }
      };

      Rubric.prototype.lowestLow = function() {
        return this.ranges().min(function(range) {
          return range.get('low');
        }).get('low');
      };

      Rubric.prototype.averageRangeIncrement = function() {
        var out;

        if (this.ranges().length >= 1) {
          out = parseInt(this.highestHigh()) / this.ranges().length;
        } else {
          out = 1;
        }
        return out;
      };

      Rubric.prototype.nextRangeLowValue = function() {
        return this.highestHigh() + 1;
      };

      Rubric.prototype.nextRangeHighValue = function() {
        return this.highestHigh() + this.averageRangeIncrement();
      };

      Rubric.prototype.updateRangeBound = function(id, type, value) {
        value = parseInt(value);
        return this.ranges().get(id).set(type, value);
      };

      Rubric.prototype.validateRanges = function() {
        var out;

        out = '';
        if (this.checkIfCollectionHasMissingNames(this.ranges())) {
          out = out + 'You cannot add an unnamed range.';
        }
        if (this.checkIfCollectionHasDuplicates(this.ranges())) {
          out = out + 'No duplicate ranges are permitted.';
        }
        if (this.checkIfRangesHaveGaps(this.ranges)) {
          out = out + 'Range gap or overlap error.';
        }
        if (this.checkIfRangesAreInverted(this.ranges)) {
          out = out + 'Range inversion error.';
        }
        if (out.length === 0) {
          return false;
        } else {
          return out;
        }
      };

      Rubric.prototype.validateFields = function() {
        var out;

        out = '';
        if (this.checkIfCollectionHasMissingNames(this.fields())) {
          out = out + 'You cannot add an unnamed field.';
        }
        if (this.checkIfCollectionHasDuplicates(this.fields())) {
          out = out + 'No duplicate fields are permitted.';
        }
        if (out.length === 0) {
          return false;
        } else {
          return out;
        }
      };

      Rubric.prototype.prevalidate = function() {
        this.prevalidationError = this.validate();
        if (this.prevalidationError) {
          return this.trigger('invalid');
        } else {
          return this.trigger('valid');
        }
      };

      Rubric.prototype.validate = function(attributes, options) {
        var errorMessage, validateMethods,
          _this = this;

        validateMethods = ['validateRanges', 'validateFields'];
        errorMessage = '';
        _.each(validateMethods, function(method) {
          var res;

          res = _this[method](attributes);
          if (res !== false) {
            return errorMessage = errorMessage + ' ' + res;
          }
        });
        if (errorMessage.length > 0) {
          return errorMessage;
        }
      };

      Rubric.prototype.checkIfCollectionHasMissingNames = function(collection) {
        var models;

        collection.each(function(model) {
          return model.removeError('no_name');
        });
        models = collection.where({
          name: ''
        });
        if (models.length > 0) {
          _.each(models, function(model) {
            return model.addError('no_name');
          });
          return true;
        } else {
          return false;
        }
      };

      Rubric.prototype.checkIfCollectionHasDuplicates = function(collection) {
        var groups, hasError;

        collection.each(function(model) {
          return model.removeError('dupe');
        });
        hasError = false;
        groups = collection.groupBy(function(model) {
          return model.get('name').toLowerCase();
        });
        _.each(groups, function(value) {
          if (value.length > 1) {
            return _.each(value, function(model) {
              model.addError('dupe');
              return hasError = true;
            });
          } else {

          }
        });
        return hasError;
      };

      Rubric.prototype.checkIfRangesAreInverted = function() {
        var hasError,
          _this = this;

        hasError = false;
        this.ranges().each(function(range) {
          range.removeError('range_inverted');
          if (range.get('high') < range.get('low')) {
            hasError = true;
            return range.addError('range_inverted');
          }
        });
        return hasError;
      };

      Rubric.prototype.checkIfRangesHaveGaps = function(ranges) {
        var hasError,
          _this = this;

        if (this.ranges().length <= 1) {
          return false;
        }
        hasError = false;
        ranges = this.ranges();
        ranges.sort();
        ranges.each(function(range) {
          var diff, index, next, prev;

          index = ranges.indexOf(range);
          prev = ranges.at(index - 1);
          next = ranges.at(index + 1);
          range.removeError('low_gap');
          if (prev != null) {
            diff = parseInt(range.get('low')) - parseInt(prev.get('high'));
            if (diff !== 1) {
              range.addError('low_gap');
              hasError = true;
            }
          }
          range.removeError('high_gap');
          if (next != null) {
            diff = parseInt(next.get('low')) - parseInt(range.get('high'));
            if (diff !== 1) {
              range.addError('high_gap');
              return hasError = true;
            }
          }
        });
        return hasError;
      };

      Rubric.prototype.parse = function(response, options) {
        var _this = this;

        if (response != null) {
          if (!this.get('fields')) {
            this.set('fields', new FieldCollection);
          }
          if (!this.get('ranges')) {
            this.set('ranges', new RangeCollection);
          }
          _.each(response.ranges, function(range) {
            if (_this.ranges().get(range.id) != null) {
              return _this.ranges().get(range.id).set(range);
            } else {
              return _this.addRange(range);
            }
          });
          _.each(response.fields, function(field) {
            if (_this.fields().get(field.id) != null) {
              return _this.fields().get(field.id).set(field);
            } else {
              return _this.addField(field);
            }
          });
          delete response['ranges'];
          delete response['fields'];
        }
        return response;
      };

      Rubric.prototype.toJSON = function() {
        var attributes;

        attributes = _.clone(this.attributes);
        return $.each(attributes, function(key, value) {
          if ((value != null) && _(value.toJSON).isFunction()) {
            return attributes[key] = value.toJSON();
          }
        });
      };

      return Rubric;

    })(Backbone.Model);
  });

}).call(this);
