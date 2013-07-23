(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'models/rubric_property'], function(Backbone, RubricProperty) {
    var FieldModel, _ref;

    return FieldModel = (function(_super) {
      __extends(FieldModel, _super);

      function FieldModel() {
        _ref = FieldModel.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      FieldModel.prototype.defaults = {
        name: '',
        description: '',
        range_descriptions: {}
      };

      FieldModel.prototype.errorStrings = {
        dupe: 'Duplicate field names are not allowed'
      };

      FieldModel.prototype.setDescription = function(range, description) {
        var descriptions;

        descriptions = _.clone(this.get('range_descriptions'));
        descriptions[range.id] = description;
        this.set('range_descriptions', descriptions);
        return this.trigger('change');
      };

      return FieldModel;

    })(RubricProperty);
  });

}).call(this);
