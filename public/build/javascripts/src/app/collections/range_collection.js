(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'models/range'], function(Backbone, RangeModel) {
    var RangeCollection, _ref;

    return RangeCollection = (function(_super) {
      __extends(RangeCollection, _super);

      function RangeCollection() {
        _ref = RangeCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      RangeCollection.prototype.model = RangeModel;

      RangeCollection.prototype.comparator = function(range) {
        return range.get('low');
      };

      return RangeCollection;

    })(Backbone.Collection);
  });

}).call(this);
