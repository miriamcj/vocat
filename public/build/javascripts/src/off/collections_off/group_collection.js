(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Collections.Group = (function(_super) {
    __extends(Group, _super);

    function Group() {
      _ref = Group.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Group.prototype.model = Vocat.Models.Group;

    return Group;

  })(Backbone.Collection);

}).call(this);
