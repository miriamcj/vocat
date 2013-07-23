(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Views.AbstractView = (function(_super) {
    __extends(AbstractView, _super);

    function AbstractView() {
      _ref = AbstractView.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    AbstractView.prototype.initialize = function(options) {
      if (options.organizationId != null) {
        return this.organizationId = options.organizationId;
      }
    };

    return AbstractView;

  })(Backbone.View);

}).call(this);
