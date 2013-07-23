(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Models.Course = (function(_super) {
    __extends(Course, _super);

    function Course() {
      _ref = Course.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    return Course;

  })(Backbone.Model);

}).call(this);
