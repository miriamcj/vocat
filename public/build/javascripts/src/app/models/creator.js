(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone'], function(Backbone) {
    var CreatorModel, _ref;

    return CreatorModel = (function(_super) {
      __extends(CreatorModel, _super);

      function CreatorModel() {
        _ref = CreatorModel.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      return CreatorModel;

    })(Backbone.Model);
  });

}).call(this);
