(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'models/flash_message'], function(Backbone, FlashMessageModel) {
    var FlashMessageCollection, _ref;

    return FlashMessageCollection = (function(_super) {
      __extends(FlashMessageCollection, _super);

      function FlashMessageCollection() {
        _ref = FlashMessageCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      FlashMessageCollection.prototype.model = FlashMessageModel;

      FlashMessageCollection.prototype.initialize = function() {};

      return FlashMessageCollection;

    })(Backbone.Collection);
  });

}).call(this);
