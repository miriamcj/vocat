(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'models/rubric'], function(Backbone, RubricModel) {
    var RubricCollection, _ref;

    return RubricCollection = (function(_super) {
      __extends(RubricCollection, _super);

      function RubricCollection() {
        _ref = RubricCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      RubricCollection.prototype.model = RubricModel;

      return RubricCollection;

    })(Backbone.Collection);
  });

}).call(this);
