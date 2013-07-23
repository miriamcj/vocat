(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'models/creator'], function(Backbone, CreatorModel) {
    var CreatorCollection, _ref;

    return CreatorCollection = (function(_super) {
      __extends(CreatorCollection, _super);

      function CreatorCollection() {
        _ref = CreatorCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      CreatorCollection.prototype.model = CreatorModel;

      CreatorCollection.prototype.activeModel = null;

      CreatorCollection.prototype.getActive = function() {
        return this.activeModel;
      };

      CreatorCollection.prototype.setActive = function(id) {
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

      return CreatorCollection;

    })(Backbone.Collection);
  });

}).call(this);
