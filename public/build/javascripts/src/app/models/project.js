(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone'], function(Backbone) {
    var ProjectModel, _ref;

    return ProjectModel = (function(_super) {
      __extends(ProjectModel, _super);

      function ProjectModel() {
        _ref = ProjectModel.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      return ProjectModel;

    })(Backbone.Model);
  });

}).call(this);
