(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'models/project'], function(Backbone, ProjectModel) {
    var ProjectCollection, _ref;

    return ProjectCollection = (function(_super) {
      __extends(ProjectCollection, _super);

      function ProjectCollection() {
        _ref = ProjectCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      ProjectCollection.prototype.model = ProjectModel;

      ProjectCollection.prototype.activeModel = null;

      ProjectCollection.prototype.getActive = function() {
        return this.activeModel;
      };

      ProjectCollection.prototype.setActive = function(id) {
        var current, model;

        current = this.getActive();
        if (id != null) {
          model = this.get(id);
          if (model != null) {
            this.activeModel = model;
          } else {
            this.activeModel = null;
          }
        } else {
          this.activeModel = null;
        }
        if (this.activeModel !== current) {
          return this.trigger('change:active', this.activeModel);
        }
      };

      return ProjectCollection;

    })(Backbone.Collection);
  });

}).call(this);
