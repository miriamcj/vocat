(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Models.ViewState = (function(_super) {
    __extends(ViewState, _super);

    function ViewState() {
      _ref = ViewState.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    return ViewState;

  })(Backbone.Model);

}).call(this);