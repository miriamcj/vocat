(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone'], function(Backbone) {
    var FlashMessageModel, _ref;

    return FlashMessageModel = (function(_super) {
      __extends(FlashMessageModel, _super);

      function FlashMessageModel() {
        _ref = FlashMessageModel.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      return FlashMessageModel;

    })(Backbone.Model);
  });

}).call(this);
