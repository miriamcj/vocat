(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Models.FlashMessage = (function(_super) {
    __extends(FlashMessage, _super);

    function FlashMessage() {
      _ref = FlashMessage.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    return FlashMessage;

  })(Backbone.Model);

}).call(this);
