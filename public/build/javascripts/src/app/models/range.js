(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'models/rubric_property'], function(Backbone, RubricProperty) {
    var RangeModel, _ref;

    return RangeModel = (function(_super) {
      __extends(RangeModel, _super);

      function RangeModel() {
        _ref = RangeModel.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      RangeModel.prototype.errorStrings = {
        high_gap: 'There is a gap or an overlap between the high end of this range and the low end of the next range.',
        low_gap: 'There is a gap or an overlap between the low end of this range and the high end of the previous range.',
        range_inverted: 'The high end of this range is lower than the low end.',
        no_name: 'All ranges must have a name.',
        dupe: 'All ranges must have a unique name.'
      };

      RangeModel.prototype.defaults = {
        name: '',
        low: 0,
        high: 1
      };

      return RangeModel;

    })(RubricProperty);
  });

}).call(this);
