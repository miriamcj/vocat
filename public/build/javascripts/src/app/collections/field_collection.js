(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'models/field'], function(Backbone, FieldModel) {
    var FieldCollection, _ref;

    return FieldCollection = (function(_super) {
      __extends(FieldCollection, _super);

      function FieldCollection() {
        _ref = FieldCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      FieldCollection.prototype.model = FieldModel;

      return FieldCollection;

    })(Backbone.Collection);
  });

}).call(this);
